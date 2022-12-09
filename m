Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D262D648178
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLILRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiLILRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:17:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B386FF00
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:17:06 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so10668314ejb.13
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 03:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea1sOggSBYXfK9RE8PHjpOsz0GR0AKuuVyApSzoxjoU=;
        b=5GhnYIyPUZLuAahZlwsFVP1DFsA1CItnJzRkz1NfvjtmdH1aaWHGacE3paTKxwOX+e
         rUPi5HnYiTpfe/5HD/fHpEgLTfpPApnWJoJc0k+AX+RywlToUkwaGTWeJe1al12WAyWE
         Vsau7G2xsG/Z6pjDtgo17rRtcbEN8EVB/fK8oX2nrOIJQFDq0BzST3zGUX+NU+1NuKMW
         vxHXAvQLabQ+BbJQPFJS7OgBzfNm2vMwlR9EgT2uqX63RT1DU6MdqSR72Q69nEGxXth7
         yo8/xhC7viA1YQz2gPsuD1auh7Q5Nrg+Gk4AYISdd2ZLYyotHFAdxEwdfiFT3PxU5OVo
         JDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea1sOggSBYXfK9RE8PHjpOsz0GR0AKuuVyApSzoxjoU=;
        b=CxZJYhYws12toHWE+JLAbQ6L6lxctLNOOvIHCaHgFmotIpWZngF6XXXeucpD6M9Gj/
         bPxm5LQMaOqp9vZ6YknQIEdwIoPLPqr0UFrbHz9C5veZO4vecvUagM+Q+/CKVUSY+bgL
         gc/+WNwq8CYYyVj399w6I7SYseiuMVEl2Afa9eMwvWwR7pw0FEJ1NSmYgl+IQrFpvvZZ
         d3FcpNBWDhpLQNPNIilQ5NOvxCP4cW9thDLIzOXvp92TGtiXg+42wLH5og5dkCKSfEB8
         zDGATpRWqqLzxTMo/foES5sR4VvSq7qGI/ZBZ48Gtcz4gfMW4gwXQLnHK7Glt1MYj/t4
         PjWw==
X-Gm-Message-State: ANoB5pmAiWGPDfNib0CiLFp2e/WpiEabmKWMoNbZJIIqAum10Pqf10+C
        iHgBxsXiqaFoiiLxc7liiWKshQ==
X-Google-Smtp-Source: AA0mqf5Cd9SZtHsxcPgS8zIS176ZslLANtIGnee5iHAXY1cJzAYvkQ9E/qGJ0AQyWy9snUAOvq3aeg==
X-Received: by 2002:a17:906:128c:b0:7a9:fc17:eb4c with SMTP id k12-20020a170906128c00b007a9fc17eb4cmr4490928ejb.40.1670584624989;
        Fri, 09 Dec 2022 03:17:04 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id si10-20020a170906ceca00b007c09da0d773sm440503ejb.100.2022.12.09.03.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:17:04 -0800 (PST)
Date:   Fri, 9 Dec 2022 12:17:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sd@queasysnail.net, atenart@kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v5 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5MZL5fv2OgVXgtw@nanopsycho>
References: <20221209103108.16858-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209103108.16858-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 11:31:08AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Add support for changing Macsec offload selection through the
>netlink layer by implementing the relevant changes in
>macsec_changelink.
>
>Since the handling in macsec_changelink is similar to macsec_upd_offload,
>update macsec_upd_offload to use a common helper function to avoid
>duplication.
>
>Example for setting offload for a macsec device:
>    ip link set macsec0 type macsec offload mac
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Reviewed-by: Jiri Pirko <jiri@nvidia.com>

You have to drop this tag when patch changes.
