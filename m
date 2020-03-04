Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8ED1797DD
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgCDS2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgCDS2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:28:43 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A148B21775;
        Wed,  4 Mar 2020 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583346523;
        bh=0s3JTtmYyRMFJaVe0c1fo7At/U0Qok2COH8GUyhoRXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtLRmbQ2+FWuvfmLNmYeK7PVJAaD8N0pAaXX+OEXAY/gVmDp2qRYk4y4/apZOZ9/o
         hfyRo3UHV/qdnsFc1orsMn/+3dYBF/4jRK01W9NDIA40B7Y0g4Bn2QsvWTy8LN5ODf
         VSJgeERQ+z1FSs0Ez3OrHayCQz5YdKc/HFUbDFTo=
Date:   Wed, 4 Mar 2020 10:28:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Michal Kubecek <mkubecek@suse.cz>, <davem@davemloft.net>,
        <thomas.lendacky@amd.com>, <benve@cisco.com>, <_govind@gmx.com>,
        <pkaustub@cisco.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <joabreu@synopsys.com>,
        <snelson@pensando.io>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <jeffrey.t.kirsher@intel.com>,
        <jacob.e.keller@intel.com>, <michael.chan@broadcom.com>,
        <saeedm@mellanox.com>, <leon@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304102840.3fb9eef2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <410f35ef-b023-1c24-f7e7-2724bae121ff@solarflare.com>
References: <20200304043354.716290-1-kuba@kernel.org>
        <20200304043354.716290-2-kuba@kernel.org>
        <20200304075926.GH4264@unicorn.suse.cz>
        <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
        <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
        <410f35ef-b023-1c24-f7e7-2724bae121ff@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 18:16:13 +0000 Edward Cree wrote:
> On 04/03/2020 18:12, Alexander Duyck wrote:
> > So one thing I just wanted to point out. The used_types won't necessari=
ly
> > be correct because it is only actually checking for non-zero types. The=
re
> > are some of these values where a zero is a valid input =20
> Presumably in the netlink ethtool world we'll want to instead check if
> =C2=A0the attribute was passed?=C2=A0 Not sure but that might affect what=
 semantics
> =C2=A0we want to imply now.

I mean... it's just a local variable in a helper... :)

I think netlink will need its own helper based on attribute presence,
as you said.
