Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD37646FBC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLHMca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiLHMc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:32:27 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E9A8BD2B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:32:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z92so1884926ede.1
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVJSAXuSWuj3v68OSqUKKOxN4D3hFXCNdAsxOa9BPCQ=;
        b=jFuwADu/rknSohNdnjBfV6ZDTfnpc/6yOLxDtWy/SFK0cE018QolLi8DCWdahBnYdR
         O6wyvbaKlEG7uiKJiMXTjQxvmA/0ztgaNJ3g7gQb6FZs78t9zJZvkClVCMjfCOIM2zN+
         1rR7lwCXV6Z/g/8KUYSlsCkOshRKf7UuDxxozF8DupzO3lLUJ+IDcNjijwycjdlR65+Q
         4Fj14YMH9ffFVp7rCO2eSOy6X38faPqabVylZr/EQ0J/7PapuONFKlMyJmfl/q8zdeiE
         zmVGkblnHKlHdFc8cbjqJFV3yOYUThgcVnN+NhiV3moFAS7utt7sJDqbPUtSEIDGOK/k
         uwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVJSAXuSWuj3v68OSqUKKOxN4D3hFXCNdAsxOa9BPCQ=;
        b=LnTy6MzJhSIqAmhdQ8pZWzpylNlAk2R0mPFr/IKc4VFjmZqs0bCmIyD3KV2zNt05qq
         akRkDGl6mp6tCVr9nyKcmOrXNabNPkwHnpnwMiZydfL9Fc2asvPp4vzj3d4BLBR4AVCA
         MLDS/x0kgzuBh17UZo+E4nYB2LS+awENPDlrtnxJgajsruVHtFh7FcTUC/bNKPhwENci
         QAOnK8bk29C91D6w1dERkgAWCehhXHNWbFpYp8miwYsbBYMXNC+AxCl3MyCABp4wu/2q
         khFDr+ADWMkBgjCPJShF4/pNr+wRnuRk5qmxjC2pD8pHTEhLD0y7hJDOyGT5ab8mZ3YT
         ggQw==
X-Gm-Message-State: ANoB5pm/0jp/vrrvU+yzJQeamLoC35Ox/OsGdLqbU/S50oW2igjBai5a
        SfgV8Tllw87JpAe7E2ggvg6WHnybqFcbMDTyE9c=
X-Google-Smtp-Source: AA0mqf6W8BfSrOOPDe1X58D15Pbr/ixGB8qxPBBDrSOzQvg5KfKLEEqIQWfrfh2AYc5HPZhODddyKw==
X-Received: by 2002:a05:6402:4006:b0:46c:d5e8:2fc9 with SMTP id d6-20020a056402400600b0046cd5e82fc9mr2543002eda.13.1670502744767;
        Thu, 08 Dec 2022 04:32:24 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dn18-20020a05640222f200b00463b9d47e1fsm3337988edb.71.2022.12.08.04.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:32:23 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:32:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org
Subject: Re: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5HZVhvkdCyJOgS6@nanopsycho>
References: <20221208115517.14951-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208115517.14951-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 12:55:16PM CET, ehakim@nvidia.com wrote:
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
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Looks fine to me.
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
