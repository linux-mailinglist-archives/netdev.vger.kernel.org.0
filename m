Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B202B561E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgKQBO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:14:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14717 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgKQBO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:14:27 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201117011423epoutp0315c8eeb0f498133a50a108f4d0be7ef4~IJo8uwIQ91410514105epoutp03b
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 01:14:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201117011423epoutp0315c8eeb0f498133a50a108f4d0be7ef4~IJo8uwIQ91410514105epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605575663;
        bh=7k8O9yozzoFciLJ0MuDuPiI5gk7/ogB2SzuNGpq4xBg=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=V1/pY0q6CGa+x8hJyQ1N8qUovr6jO6iMlryz7LhrLtv/EpaE9LEKe6+P7jbfIdLfB
         2xh/HPNCKsjja8N+z8VDORCazgG6U9UuqmKLKwOK3FGniHSLXpYYQuolhxZR0W7bSj
         Bx9VovfAkh2N3jo44s3e4+OeXelugEX4L5uHr5WI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201117011423epcas2p1d6b1606848e9154335aa6505b12906e8~IJo8aFXDn1946919469epcas2p16;
        Tue, 17 Nov 2020 01:14:23 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CZnz05nnvzMqYm5; Tue, 17 Nov
        2020 01:14:20 +0000 (GMT)
X-AuditID: b6c32a45-8dc16a800001297d-54-5fb323ec3a39
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.E1.10621.CE323BF5; Tue, 17 Nov 2020 10:14:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next v2 0/3] nfc: s3fwrn5: Refactor the s3fwrn5 driver
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "krzk@kernel.org" <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>
CC:     "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201117011420epcms2p28407a6596fdf1e63cb84af98fa768566@epcms2p2>
Date:   Tue, 17 Nov 2020 10:14:20 +0900
X-CMS-MailID: 20201117011420epcms2p28407a6596fdf1e63cb84af98fa768566
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmqe4b5c3xBpOn6llsaZ7EbnF74jQ2
        i/PnN7BbXN41h81izobN7BbHFog5sHlsWtXJ5tE9+x+LR9+WVYwenzfJBbBE5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZHydnVkwg6Xi
        TXszcwPjAuYuRk4OCQETiStrVrB1MXJxCAnsYJSYsOsaSxcjBwevgKDE3x3CIDXCAl4SD5+/
        ZgWxhQQUJf53nGODiOtKvPh7FMxmE9CWWHu0kQnEFhGolpi2/x0zyExmgdWMEp0/O6GW8UrM
        aH/KAmFLS2xfvpURwtaQ+LGsF6pGVOLm6rfsMPb7Y/OhakQkWu+dhaoRlHjwczdUXFLi7b55
        7CDLJATaGSXO//zBBuHMYJQ4tfkvVIe+xOJzK8DO4xXwldh06RfYOywCqhL75t6EmuQi8efk
        O7DNzALyEtvfzmEGhQSzgKbE+l36IKaEgLLEkVssEBV8Eh2H/7LD/LVj3hMmCFtVorf5CxPM
        j5Nnt0BN95C4dPssIyQQAyVWnnzOPoFRYRYiqGch2TsLYe8CRuZVjGKpBcW56anFRgWGyJG7
        iRGcDrVcdzBOfvtB7xAjEwfjIUYJDmYlEV4Xk43xQrwpiZVVqUX58UWlOanFhxhNgT6eyCwl
        mpwPTMh5JfGGpkZmZgaWphamZkYWSuK8oSv74oUE0hNLUrNTUwtSi2D6mDg4pRqYJqWyPnlS
        +dFA7Xqd0NqXdkfvKR+ZGGqs7PNSfUO/4avGve6Gj8RkE+2nv2A99KOI/aPfQd9JZ0O2/TBn
        +F0q+chI/3Zt01Zbk8eP9dtmf3aYGB79a3pyrZSYz7nXZoI920Is3732WvDtQkLvaTGD5dfS
        e7kW1jm8Ka/I+uLroPKiaP7WDq2zS/cFzTDj+Jkwtbd4vRGf6Bld7Q0vG62VpIRq3z5XN1LT
        L+V6qXMhsoibu3vNaykLDwU23flnjrypbl3AsDC8a8O2kpMzpaNPR3Z7/Tp6rdrn58a7rcfL
        F84TamfeFBX0K+LPE//jKzI3B/0LmnQkZuINq8PKZxOk+lo7Vk+IDZRen8N2auoxJZbijERD
        Leai4kQA+ry43BAEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201117011420epcms2p28407a6596fdf1e63cb84af98fa768566
References: <CGME20201117011420epcms2p28407a6596fdf1e63cb84af98fa768566@epcms2p2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v1:
- Remove the trailing dot from subject.
- Remove an empty line at beginning of commit message.
- Add a commit message.

Bongsu Jeon (3):
  nfc: s3fwrn5: Remove the max_payload
  nfc: s3fwrn5: Fix the misspelling in a comment
  nfc: s3fwrn5: Change the error code

 drivers/nfc/s3fwrn5/core.c     |  3 +--
 drivers/nfc/s3fwrn5/firmware.c |  2 +-
 drivers/nfc/s3fwrn5/i2c.c      |  4 +---
 drivers/nfc/s3fwrn5/s3fwrn5.h  | 11 +++++------
 4 files changed, 8 insertions(+), 12 deletions(-)

-- 
2.17.1

