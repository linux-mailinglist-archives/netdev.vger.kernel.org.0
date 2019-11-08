Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13BCF3DE5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKHCM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:12:26 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39275 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKHCMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 21:12:25 -0500
Received: by mail-qt1-f195.google.com with SMTP id t8so4740417qtc.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 18:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eAgTqO2CBGsFfoPKpJ+zoPJCqaIJ3RlYgE4wqrS13Hk=;
        b=Hcqa1Osn/dHZWkILtOOY2fDMYaArvCcqRPgPNElaMU75F5O8a4296CYXGxCcgM7BTT
         YVrUA342zbusmIkNvZ9cEJamjYHrhMzxQqOCtaDgzXjkxNh99MRSp1QUhA79ceh7dAT+
         YecR9sWRIc2rxiiDirJ/U5KbVv7FFwfYYdvth7uTnmcfhQMCv4MMhGxkrh9BnT7Wni7S
         ZlppnTnqtmbM4AB6jSlA9STOZhTsZ3Lh4uZzO/e0WMx7fFrduv/FC7jrPl78KxugA6K3
         uiYCxHsSVQnvWXgvtCGMefgY//taSdfLSTGQPYFjcdSNDJ3oMivIFFlfGoAnlirNU+5K
         pdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eAgTqO2CBGsFfoPKpJ+zoPJCqaIJ3RlYgE4wqrS13Hk=;
        b=ngKqUqfG+yJteWw9shNqlNuEfkeCKyWJpLL7uJN7lF4YAw9GkKcJCbfljO1EIO2xUX
         QH0WMgULuqKH9+pJdol/LxGZDkwFU2EHBGXWKakwROc9wa2zIKYhi97y2h9jzGQS2irs
         HKDPe6kI2B2Ceb5JEoxsc1IIDqqBlXogO7AyLfUBE8FYA2gZScgqKp08KLwiDA3aRDuF
         xdbmqQF+bifKBU6dtU/Hx/xYPGTuzwtbgS+S+oEvRndbcjQ0FtWx8l822dOMndmio9cf
         x8u2KvGp7lHTJCLx/P5wi6f0gxsQthB63+6T7P1KlwyeDEH1SdC713M2BNuJM4kqLoxz
         lTIQ==
X-Gm-Message-State: APjAAAVnLMNggjbpQIL0WmY0WjbIIPqGIMYSiIghae8kJwpAtpkRkwT/
        pfnPi1Owk6Bwdugy9zjhiI7aXg==
X-Google-Smtp-Source: APXvYqxPB8R3pI8IZ8O00rOVtc4vWXkeE67gsczJNXPQcKMptySyqAb90uxdq5yrBVkKrPL96z/Cmw==
X-Received: by 2002:ac8:7b91:: with SMTP id p17mr7548688qtu.318.1573179144640;
        Thu, 07 Nov 2019 18:12:24 -0800 (PST)
Received: from cakuba ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id a137sm2106325qkg.75.2019.11.07.18.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 18:12:24 -0800 (PST)
Date:   Thu, 7 Nov 2019 21:12:20 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191107211220.798321c4@cakuba>
In-Reply-To: <AM0PR05MB48668E29F1811F496602079ED17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <AM0PR05MB4866A2B92A64DDF345DB14F5D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191107201627.68728686@cakuba>
        <AM0PR05MB48668E29F1811F496602079ED17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 01:49:09 +0000, Parav Pandit wrote:
> > > What I remember discussing offline/mailing list is
> > > (a) exposing mdev/sub fuctions as devlink sub ports is not so good
> > > abstraction
> > > (b) user creating/deleting eswitch sub ports would be hard to fit in
> > > the whole usage model  
> > 
> > Okay, so I can repost the "basic" sub functions?
> >   
> I think so. Would you like post on top of this series as port flavour
> etc would come by default? Also there is vfio/mdev dependency exist
> in this series...

I don't mind the ordering.
