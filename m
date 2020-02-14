Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE315F480
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394804AbgBNSVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:21:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41315 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbgBNPto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:49:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id j9so5066218pfa.8
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 07:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p9FeIm4rpsTmwD29DWrrG41+mpG32pb6yqgUygjNEWQ=;
        b=B0Xg3jtIrNSru02e/vY1KtDPkuH4UxegX8g5TRSRMNV6VRuYvHYV/ecq2oas1w1OD6
         Z7BwiHlgW/eQXzZexWVyDQpEovi9GHFIUrF2R4W+EOfhwlRLkZRCn7ea+M/RJiVYT5FD
         eBFYkQUsOYg7NkLeeqnE0qrcEuV/8D4QstBKXcST0T5XrBypi7/vXqmRdkUWDkRzb8/G
         EmmKOmTsqvclBhadLdnNAUTceNLO9VjgVBFRkN6JVUOd5hkN3FuTZbSkIYsCeXGP5WNF
         P2w1GekhLuP5Za3h3hYgxIXkDH0m4/8MQTKs2JfbSgearm9AvFg25l00K9ZWhtUmN9XO
         LJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p9FeIm4rpsTmwD29DWrrG41+mpG32pb6yqgUygjNEWQ=;
        b=coXFbdcIVoLbpHyROeirD/kaHFp2X3iI3mS80Qp2uELlquRoWFO+A9f0Xf9Ccdv64K
         ZfX/TbIdzecaRBCutLJuK5y0C9qRq7OGPeU0x3KVSMBskppT9N9hCrjeiIotxdhsJV8r
         uYooCWqhmvVWAoz8Vliz44hyraSNx1b0hw7SWm3sER8YbNlnq+FxdfmLhQ5TU0ppqajH
         j8hfrI/N0rNrdGvYMYfTFI0DmqzYqyWVpAI00BIwLRd8Xf0h4ALwb7F4Ogng5lWePqT9
         10cDpeyYY5ClYv9h9KcrC6kRCelzsTGuhZMSNEQU0TkWUKcdCqq2+KpA37zJH+WahFaI
         QWiA==
X-Gm-Message-State: APjAAAXLEDjlYDM5E3+hYSw8hqn64ZIFzSXwdVwBPi67rJ+VIG7sRQv8
        HvKQqr8G38vJr3Yx88Gzr7LOdg==
X-Google-Smtp-Source: APXvYqwuv9lTVPd0VibPK3oC1NpGvEAA9AH5kdTzT673M8UN18i0sZKbEp/ESIHcYPqq7v3kwjuuyw==
X-Received: by 2002:a05:6a00:2c1:: with SMTP id b1mr4215205pft.80.1581695383303;
        Fri, 14 Feb 2020 07:49:43 -0800 (PST)
Received: from [192.168.4.6] ([107.13.143.123])
        by smtp.gmail.com with ESMTPSA id ep2sm6805972pjb.31.2020.02.14.07.49.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 07:49:42 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC PATCH v4 18/25] RDMA/irdma: Implement device supported verb
 APIs
From:   Andrew Boyer <aboyer@pensando.io>
In-Reply-To: <20200214145443.GU31668@ziepe.ca>
Date:   Fri, 14 Feb 2020 10:49:38 -0500
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E686D00B-5B27-4463-ADB1-D01588621138@pensando.io>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-19-jeffrey.t.kirsher@intel.com>
 <20200214145443.GU31668@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 14, 2020, at 9:54 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Wed, Feb 12, 2020 at 11:14:17AM -0800, Jeff Kirsher wrote:
> ...
> New drivers are forbidden from calling this:
>=20
> /**
> * rdma_set_device_sysfs_group - Set device attributes group to have
> *				 driver specific sysfs entries at
> *				 for infiniband class.
> *
> * @device:	device pointer for which attributes to be created
> * @group:	Pointer to group which should be added when device
> *		is registered with sysfs.
> * rdma_set_device_sysfs_group() allows existing drivers to expose one
> * group per device to have sysfs attributes.
> *
> * NOTE: New drivers should not make use of this API; instead new =
device
> * parameter should be exposed via netlink command. This API and =
mechanism
> * exist only for existing drivers.
> */
>=20
> Jason

Is there an existing field in RDMA_NLDEV_ATTR_* that allows us to =
display a string to use as a replacement for the board_id in sysfs?

Like =E2=80=9CMellanox ConnectX-3=E2=80=9D or similar.

The other two sysfs fields (hca_type and hw_rev) seem to have been =
unused.

-Andrew

