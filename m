Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F352565EE56
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbjAEOGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjAEOGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:06:03 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82605F4B4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:04:48 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so3441806pjb.1
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 06:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/OW2EBk1erk8KHg4qlJ3fGkh7MehBtIqWg1IljsvMs=;
        b=K0vzJ9nKpTOqAXLb4Uf0IQEmwDh+U2GI7znG+ECA0iJ7WOCvp5h0eDc4e7xFXvF14V
         j02nib0HOwhcbV/evJC0IXboO59D+nEebNcnUU2/K4Aa+kyR+OIMXZ6LTDlzhIkW5yFJ
         MkgH3R0Pa+M1zmBe0sdoDCkOZQHF6Q9EwgGxHidx5/wLBaYJDjisQ0VXFQ3Bp9b8in+8
         9sWRlmOXuYYgQov0LmEtPF77o1S5E8G1pY/ATzK0uAkDTEFlbk/UI1iBHeV9/F+AQp/G
         BM7A9lQ3hGHdJkCnaJQNw58i2tIhtB2i2YXmE6Cx2h7SH0cDFwWaoBukmOR3Ogv2X0dl
         ESsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/OW2EBk1erk8KHg4qlJ3fGkh7MehBtIqWg1IljsvMs=;
        b=iLzh72103C3kb7seQ6cmcCRWHvixZS+HU06e0D156IsleF/1PQrN7tJa4d7n1erZWp
         4X2q8CgmcVvDUW9hRELfPbf7AfbZhEZ5/urA3dtTr7ZdArmTVsTAfFqb8CukfcUwgqeA
         OMjNFIsAZo6pMpam72xqSxuxaxbv5UgpuV19pye90fZZqiwvE2FPHlznVhw4eNv4u/Hh
         h2z9qT4RJMRmNJfDKzrLmm4QebWMvzVVA+Xftxn6wrnafIV3EJEKnvqaX1Pw1jaT8hYY
         QYZPWuQqSd0vO2EUleQDoxioqRJ9s+WvSAlZiJw3VdNmpqh/TsuRKdAdutII8rbGrOvs
         Fjbw==
X-Gm-Message-State: AFqh2kqtCFUPMD6dKqJGbh5Mtg5ix0ub09vYe7jrNHAKNK1qQtWCiEs/
        GnVO++asaF3MaedFmkkXnM51+A==
X-Google-Smtp-Source: AMrXdXu7+nRRZmsEPqpBmizoAXVor4ILKfweC9h2KFV/re3Qsmvn/Iv2wFILYcCYSvOD0dwzhyiINA==
X-Received: by 2002:a17:902:82c4:b0:192:622a:ff9c with SMTP id u4-20020a17090282c400b00192622aff9cmr48981765plz.39.1672927486434;
        Thu, 05 Jan 2023 06:04:46 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b00192fe452e17sm1360138plc.162.2023.01.05.06.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:04:45 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:04:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sd@queasysnail.net, atenart@kernel.org
Subject: Re: [PATCH net-next 0/2] Add support to offload macsec using netlink
 update
Message-ID: <Y7bY+oYkMojpMCJU@nanopsycho>
References: <20230105080442.17873-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105080442.17873-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole patchset emails, including all patches and coverletter
should be marked with the same version number.


Thu, Jan 05, 2023 at 09:04:40AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>This series adds support for offloading macsec as part of the netlink
>update routine , command example:
>ip link set link eth2 macsec0 type macsec offload mac
>
>The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
>the second patch of dumping this attribute as part of the macsec
>dump.
>
>Emeel Hakim (2):
>  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
>  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
>
> drivers/net/macsec.c | 127 ++++++++++++++++++++++---------------------
> 1 file changed, 66 insertions(+), 61 deletions(-)
>
>-- 
>2.21.3
>
