Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB41E8C48
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgE2XnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:43:13 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11855 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2XnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:43:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed19dbb0000>; Fri, 29 May 2020 16:41:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 29 May 2020 16:43:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 29 May 2020 16:43:11 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 May
 2020 23:43:11 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 29 May 2020 23:43:11 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.87.173]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ed19e0f0000>; Fri, 29 May 2020 16:43:11 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 0/2] vhost, docs: convert to pin_user_pages(), new "case 5"
Date:   Fri, 29 May 2020 16:43:07 -0700
Message-ID: <20200529234309.484480-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590795707; bh=YGmAq3nPG773jqlapIIC8wphgZ+qilqK1Srd8ILtVbE=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=flEZCflRp75MhHNWbg1/Xev2qiSNgB5076pEgQNKvvKdTUtMCa414uKtWGlLVcFU9
         uJa1w2GY52kw/+HbMjQqA/kuXwdkWZ9Ync/OkwvpRXSUx6yujeot5QZI9/lY4jirWy
         RwBaM8e9hBLG8qfbtApZuaP5J+Rfa3feaiDdvYBMKY5xk+NxBODeznsB1GUVWZROk8
         brlyeDtPb/mnGz2o4LTrrfsAQKg3bG8q89O0JF0W28Y/EuZswAf5r4uwkcLFpKdMTo
         Y6iI7Da8uV/7I78ZcvvmIG+BfSRBI6l/tHGZmHDyl/JIB9YfP6ylFfmLFFreOAKAqK
         H89+wubQ5nAJg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It recently became clear to me that there are some get_user_pages*()
callers that don't fit neatly into any of the four cases that are so
far listed in pin_user_pages.rst. vhost.c is one of those.

Add a Case 5 to the documentation, and refer to that when converting
vhost.c.

Thanks to Jan Kara for helping me (again) in understanding the
interaction between get_user_pages() and page writeback [1].

This is based on today's mmotm, which has a nearby patch to
pin_user_pages.rst that rewords cases 3 and 4.

Note that I have only compile-tested the vhost.c patch, although that
does also include cross-compiling for a few other arches. Any run-time
testing would be greatly appreciated.

[1] https://lore.kernel.org/r/20200529070343.GL14550@quack2.suse.cz

John Hubbard (2):
  docs: mm/gup: pin_user_pages.rst: add a "case 5"
  vhost: convert get_user_pages() --> pin_user_pages()

 Documentation/core-api/pin_user_pages.rst | 20 ++++++++++++++++++++
 drivers/vhost/vhost.c                     |  5 ++---
 2 files changed, 22 insertions(+), 3 deletions(-)

--=20
2.26.2

