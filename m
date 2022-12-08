Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE3646FC3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLHMcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiLHMcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:32:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC97263D2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:32:36 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ud5so3498524ejc.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Y2a8wZmHQ7xJBhZck2uHOTSIO6ouTN3D8xAJmd+MFg=;
        b=WPR544T/Rm4b4/VIuZ5V6JqbCdUSX6XcyMce8sEQcxfW0IrkvygQbVUn9hUXS+Wiqr
         +B1Ax+myuzdTxf4AjV1uAkFgS5NxzDcVXctDXIW/nwAad1aanagA234Ls/h/2svCh8v6
         7wY/vp0w9+gsPZKIidHIoGRRfzS+/CKkvi3NcNE/twBulw6YWInmyhCpaogHI0XJJQSM
         GMdG7F154+DmPGmQ32j72lXhlktdwSbKluhi/uKT0SFWgI8ILoiF4qc7n9lHViTRypYU
         DTLsDnReqDaeTJy3N6ZSGaIXEJQP50Av+ddG4SphcA2jgTpNNMt1Fw8eva4BBsL8776W
         O88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Y2a8wZmHQ7xJBhZck2uHOTSIO6ouTN3D8xAJmd+MFg=;
        b=PPqHufGhwWs1brEnRNG+SDpjncmo7VjFSlRNz6/EkWpTqnZQqGzk9VIsRL4FNBhIhZ
         ktsbKV4ONRkEeOOCOXuvDjD1RtfBiXhY02RUemyBnR3qhL7K6jtbtdIxhnJN20GKtD/G
         5Ae5gcIsxlyQ3tFwIJ5bpHRcW2AlPiIIkjWTgXaZ3Qx4ZXNAg8e4dSaMIrzTgg/pP/Dd
         ybiHKGaqI1NbfY2C3kijCQ7BzniaecNNq/fKevo7xP4f9lftSf17tcoe9E8ZNDjtxmdL
         ZTfAfrTNlIfsLF6g5NabXrQEZMIHY3W40BKwS9aUcE0AByLn+5PEzMrjsoFvuUyef65q
         tAFg==
X-Gm-Message-State: ANoB5pl8B9aoXcXnFr9guY0Z2bbyZQ6qGTmGqgLstmaT6SKoGe0emdS5
        A9RmHTnScwMAD8okp0beRqxJ3L/RPrAPJOcfjSo=
X-Google-Smtp-Source: AA0mqf4YOH7cro3Nk3pF50Ge4xHDbILQxViYznwfgC4Nlmj1aM5qzipCEpHMWGpoMs+J6eajmw/AVQ==
X-Received: by 2002:a17:907:b605:b0:7c1:23f2:5b59 with SMTP id vl5-20020a170907b60500b007c123f25b59mr1975890ejc.51.1670502755058;
        Thu, 08 Dec 2022 04:32:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ca13-20020a170906a3cd00b007c08439161dsm9674266ejb.50.2022.12.08.04.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:32:34 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:32:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org
Subject: Re: [PATCH net-next v2 2/2] macsec: dump IFLA_MACSEC_OFFLOAD
 attribute as part of macsec dump
Message-ID: <Y5HZYNvx5k2J4Nn+@nanopsycho>
References: <20221208115517.14951-1-ehakim@nvidia.com>
 <20221208115517.14951-2-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208115517.14951-2-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 12:55:17PM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Support dumping offload netlink attribute in macsec's device
>attributes dump.
>Change macsec_get_size to consider the offload attribute in
>the calculations of the required room for dumping the device
>netlink attributes.
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
