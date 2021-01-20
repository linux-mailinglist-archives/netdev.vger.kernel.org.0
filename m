Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4BB2FCC28
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbhATH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:56:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729568AbhATHzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611129224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WlP6HTPmgS7QcwkM412p+X8zJad//nJVCA8QPjKz66o=;
        b=YOuX0cfFieNM5pclEhQxhWRZz7sa39/exCR/YyRnfD153Bz+Tdpyvg4oJChOvSV4q5v2Au
        zEslC6Gi0Ew400PeH2xe/EpSqakqAfvLi6dRdYOr4XsodYhu04h18RxIe+LK4jGhQwXYU7
        2qmocVz1l4lxBUN+EM1Ymuki+xknCwA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-uLtNMl_6O3mxDfxcWCP_wg-1; Wed, 20 Jan 2021 02:53:42 -0500
X-MC-Unique: uLtNMl_6O3mxDfxcWCP_wg-1
Received: by mail-wm1-f70.google.com with SMTP id k67so958778wmk.5
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:53:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WlP6HTPmgS7QcwkM412p+X8zJad//nJVCA8QPjKz66o=;
        b=KbUauSnCJsYbSJW3HSeVZFCEUvtajB9I/QCzEzSbdEMajkha+lapRFqT9e3iRLCCAO
         M7S9JqJeQZLVko8zwMsAKGYSVafPHRK8ei+quc5zAcTBI860Vkxu6SnLbcElLzsz3x+b
         GZptViJnG1HjGh+qEOgB2M0zyFTwY3Ds64tQlzwrIPT0QUqA3NgVGa3MYCqtRxMwp6DO
         xWVMUnAd7kLJU8lQm7HuhaNDRHWMpqKuem4DYKR3ZS0VnLSH2CURkWM+94DlYCHojvDO
         YFHHjuaiMyK0kPlfP7PRjA4oZbuCWdc+MoVNhOmSGcmvAxA2QSFuh/h7FbPzAueaK9KZ
         cdAA==
X-Gm-Message-State: AOAM532fX8CHggF6FhopCp7wIc541chRNOjO+8mpVYGvy7sit/Ejmfq6
        ZBCyWamGz7+h8je5k3GmAuJsDQsGoiKxagAG1z2tdu1rlABDF3ouXNEmkfcjT7SOlI0oItPtdl5
        nCc6hCbAiCVOvUaQ9
X-Received: by 2002:a5d:5112:: with SMTP id s18mr7751741wrt.267.1611129220865;
        Tue, 19 Jan 2021 23:53:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXLH//Uy8f5/X2BagDxiDXrol049atvxYIO2T3hpG/SPBNOzX/Q9yiywJPE8c+vCWAtYa52Q==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr7751727wrt.267.1611129220717;
        Tue, 19 Jan 2021 23:53:40 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id a16sm1374033wrr.89.2021.01.19.23.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 23:53:39 -0800 (PST)
Date:   Wed, 20 Jan 2021 02:53:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Message-ID: <20210120025249-mutt-send-email-mst@kernel.org>
References: <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
 <BY5PR12MB432239B28EC63D80791E1459DCA40@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB432239B28EC63D80791E1459DCA40@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 06:03:57PM +0000, Parav Pandit wrote:
> Hi Michael, Jason,
> 
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Friday, January 15, 2021 11:09 AM
> > 
> > 
> > Thanks for the clarification. I think we'd better document the above in the
> > patch that introduces the mac setting from management API.
> 
> Can we proceed with this patchset?
> We like to progress next to iproute2/vdpa, mac and other drivers post this series in this kernel version.

Let me put this in next so it can get some testing there for a week or
so.

