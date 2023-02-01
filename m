Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EE686B13
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjBAQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBAQE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BF83F29F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675267420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b1H9S6BHMI3ZJyJH5QgphGWijBn41dRJFzhUalzPkqw=;
        b=VadTuuE7Fg8qRfGQ0ErgW71z1MdOELLi5cHq8K+cJ3eSGr+4IoVddSd2YSJhMzHnARAFc/
        MPhGZTcQwPbGRLLzaDNOQMgY0FGH1PFuoXkMagQTFx4SxALdqjk0p+tr9pdmWaGhL/nl4q
        eBmleTr9fIGSpEepo3lVHDwlD2Ml/ys=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-347-zQlnq_lcMPOok38KOlj7jQ-1; Wed, 01 Feb 2023 11:03:34 -0500
X-MC-Unique: zQlnq_lcMPOok38KOlj7jQ-1
Received: by mail-wm1-f70.google.com with SMTP id l19-20020a7bc353000000b003dc554c8263so5758959wmj.3
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 08:03:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1H9S6BHMI3ZJyJH5QgphGWijBn41dRJFzhUalzPkqw=;
        b=6XcnyZ0TNklM7ZrAVEs6nmgfs+s61zaKo/vNxUFvAgcqZ2jOqGo6etFSGpHMf7DQ7K
         jKOiefPyWabmQxfQLAveWorhUbYpouSQU6wCrk2jt6RPlOsJgrjsVdtPvteRd/arZrhj
         RXv32SSHQ2Ro7rGz810dCvlNXIG+DW2CBuZj3DenANram4HJx5Joq67FkTVZvXV9hMur
         x4vclaIEcocT1It49Vow8kA/g8zdIw3+yljjPSCKy1UxU4/7VC3dBX+cq8Bhjid2TZLx
         BNVaZFbW05PJrbFpNTjjxwSsqlKpmmKdw5seT972Yuz1+E33lk5d1moUMX1SgeoHbMUb
         lU0w==
X-Gm-Message-State: AO0yUKXFPXZgLHrd+YQomURC9+H/bg/Csw81VQD4M9d0vqvn9y4xodAx
        bsORcIRn1U5uvPgCIXomsqPiXNwLhDr40XBGBKpDx6Llsv7LFRfMeWHCmG3qQG9a/9EgUvwAGcZ
        fM7M2M3YJErw/BtYU
X-Received: by 2002:a05:6000:80e:b0:2bf:e61c:9b4 with SMTP id bt14-20020a056000080e00b002bfe61c09b4mr3116852wrb.4.1675267413053;
        Wed, 01 Feb 2023 08:03:33 -0800 (PST)
X-Google-Smtp-Source: AK7set9mkTqfA7HywIzLWLc57g9ZcuE/3dWDYMdAt3c3LDfa20GdCpoBqXPbTzeqKwveMvOdDdv25g==
X-Received: by 2002:a05:6000:80e:b0:2bf:e61c:9b4 with SMTP id bt14-20020a056000080e00b002bfe61c09b4mr3116833wrb.4.1675267412882;
        Wed, 01 Feb 2023 08:03:32 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id a18-20020adffad2000000b002be53aa2260sm18737017wrs.117.2023.02.01.08.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:03:32 -0800 (PST)
Date:   Wed, 1 Feb 2023 11:03:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain
 fails
Message-ID: <20230201110253-mutt-send-email-mst@kernel.org>
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
 <20230201105200-mutt-send-email-mst@kernel.org>
 <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:54:53PM +0200, Alvaro Karsz wrote:
> > I'm not sure this is a good idea. Userspace is not supposed to be
> > able to trigger dev_err.
> 
> dev_warn then?

dev_warn_once is ok.

-- 
MST

