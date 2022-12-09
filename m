Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0819B647FCD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiLIJDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLIJCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:02:47 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB779589
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:02:44 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id t17so10026316eju.1
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 01:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ml4uQdL2LKYdwrPVo83/jU4ECyqWWVioxy8YQNnT+VY=;
        b=nh4kgLU1fvGyfQXiNVbiwBL5S6HGfrA3MKIcKYxklaF/kZle50Ivua9dSIeZfdN8A4
         OK6MkEd4xG8Yi4PMYk9d96G5UST5rsE+BdbigsZ0JaUpPMh9KlPyNz+Mm24my4YWrA6a
         mwT4GYxdfdd9UQ70QEtxnKdyYZW1VJ0dVpMzWqY+nsrkPSb1jrs/I5RfKRA94KKWLsH3
         geW6/PN5dNTRimPmKktXV10ZinWHAtB/4b92KamM6BIrA/qcCwQXHF9oPCP4n9xzrlfc
         oJiSCT+K1b1RPMwaWaZsXcee0H1+uk/2sQ1bDXejsqb/plkHhC1FUZ6wU1xZ/l7mWtrX
         ZC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ml4uQdL2LKYdwrPVo83/jU4ECyqWWVioxy8YQNnT+VY=;
        b=CYXxm7E1fu5mKHzNUfNkoq50KLIYW0bQgvSDmUoT+rpS4sKVovAL5ZjXQ3uBa1hH+x
         YtrjT79zcN6E/r3NXHJkZrRCvVVBQ1buecRGi/nnP7nN/mKxuWdwv2IFEFl76218upcI
         hDO9dTe9SzIVlOE56couUCuBg+StRS1Fy+0fa4vkuxFA5d/C8uailHuUyFsMjKK/4kbZ
         /6ftCntRZGA7mMZPH4vjL2dTe0h9aGlamvAf/n1OXlhRGyIO0UG8FXahdehIX6ueFF8A
         lgFAvjggvL3CQc7tZenkiZV52pcZEJ5X1tQd6vZ4G2THDO0kef1ZbBUCcvvgCXFKKDib
         VsWQ==
X-Gm-Message-State: ANoB5pktiO9fLXfma5E03svIjoslTPP3zzVHP8KBiO4Mp8LA2NOAIsZw
        /JGU9pleBy6e4sA4RtKxuOZmNw==
X-Google-Smtp-Source: AA0mqf53770UPgeL0qzpYQ90NARZ+cIC/EtfK2+HzPk91Z0JCm8/vUT7SlGUvJNdDP0ajwpOXz+Mdg==
X-Received: by 2002:a17:907:9712:b0:78d:f459:7186 with SMTP id jg18-20020a170907971200b0078df4597186mr8592530ejc.49.1670576563293;
        Fri, 09 Dec 2022 01:02:43 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id sh39-20020a1709076ea700b007bb32e2d6f5sm295193ejc.207.2022.12.09.01.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 01:02:42 -0800 (PST)
Date:   Fri, 9 Dec 2022 10:02:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     yang.yang29@zte.com.cn
Cc:     salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brianvv@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next] net: hns3: use strscpy() to instead of strncpy()
Message-ID: <Y5L5sZy3ks3MxYsM@nanopsycho>
References: <202212091538591375035@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212091538591375035@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 08:38:59AM CET, yang.yang29@zte.com.cn wrote:
>From: Xu Panda <xu.panda@zte.com.cn>
>
>The implementation of strscpy() is more robust and safer.
>That's now the recommended way to copy NUL terminated strings.
>
>Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
>Signed-off-by: Yang Yang <yang.yang29@zte.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
