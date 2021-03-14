Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BECD33A392
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 09:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhCNIbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 04:31:36 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:59550 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbhCNIbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 04:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615710679; x=1647246679;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=GQ+i1xludG2Xb4XWbrdhglcrsUjEy7bLMCuqG41502s=;
  b=Nwr1zyLrPJR94JsB7nDvi944q/qGv+XtlWdJoHpTsv+kgUgYQaFvsgPg
   oF9gFGZm7jUk/IrbPH7y7cSWkt5NPj6EkEoFF9IU4KgjGha5act54zghQ
   mlr7G14ySJv40b/X5qcXuyO0hDo+VrB0RWULxe8Fr2Dt817cuK8kCm4X7
   E=;
IronPort-HdrOrdr: A9a23:LGdqiqEdB6nymfvHpLqFupHXdLJzesId70hD6mlbTwBTeMCD09
 2p9c5rtyPcojAXRX0mhJS8KLCNKEm9ybdZw6k0eY2jUg7vpXeyIOhZhuHf6hDpBiGWzJ876Y
 5Of6RyA9X7DxxboK/BkXCFOvk6xt3vys2VrMP/61socg1wcaFn6G5CazqzNkFtXgFJCd4YOf
 OnifZvnDardXQJYsnTPBBsY8H4u9bJmJj6CCRpOzcb7mC14Q+A2frTNzCq+DBbdxtu5PMY3U
 3so0jF1pyO2svLqSP05iv6y7xkvvyk7vd/LOGlt+B9EESIti+YIKJ7W7ODuzgx5MWi8kwjnt
 Xtjn4bTqBOwkKURE2O5T3wxgfn0DEhgkWSr2OlvQ==
X-IronPort-AV: E=Sophos;i="5.81,245,1610409600"; 
   d="scan'208";a="97106650"
Subject: RE: [net-next PATCH 05/10] ena: Update driver to use ethtool_sprintf
Thread-Topic: [net-next PATCH 05/10] ena: Update driver to use ethtool_sprintf
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 14 Mar 2021 08:31:10 +0000
Received: from EX13D06EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id C8D75A2400;
        Sun, 14 Mar 2021 08:31:07 +0000 (UTC)
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA002.ant.amazon.com (10.43.165.241) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 14 Mar 2021 08:31:06 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.012;
 Sun, 14 Mar 2021 08:31:06 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>
Thread-Index: AQHXF2gH1xVQ4F+JPk6+np3l7a1YHaqDKUfQ
Date:   Sun, 14 Mar 2021 08:30:46 +0000
Deferred-Delivery: Sun, 14 Mar 2021 08:30:19 +0000
Message-ID: <c0aefd974f084847b213e3e841644830@EX13D22EUA004.ant.amazon.com>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
 <161557131360.10304.1549281998235246752.stgit@localhost.localdomain>
In-Reply-To: <161557131360.10304.1549281998235246752.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.135]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWFyY2ggMTIsIDIwMjEg
Nzo0OSBQTQ0KPiBUbzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnDQo+IENj
OiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBvc3MtZHJpdmVyc0BuZXRyb25vbWUuY29tOw0KPiBz
aW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsgeWlzZW4uemh1YW5nQGh1YXdlaS5jb207DQo+IHNh
bGlsLm1laHRhQGh1YXdlaS5jb207IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOw0K
PiBqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbTsgYW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb207
DQo+IGRyaXZlcnNAcGVuc2FuZG8uaW87IHNuZWxzb25AcGVuc2FuZG8uaW87IEJlbGdhemFsLCBO
ZXRhbmVsDQo+IDxuZXRhbmVsQGFtYXpvbi5jb20+OyBLaXlhbm92c2tpLCBBcnRodXIgPGFraXlh
bm9AYW1hem9uLmNvbT47DQo+IFR6YWxpaywgR3V5IDxndHphbGlrQGFtYXpvbi5jb20+OyBCc2hh
cmEsIFNhZWVkIDxzYWVlZGJAYW1hem9uLmNvbT47DQo+IEdSLUxpbnV4LU5JQy1EZXZAbWFydmVs
bC5jb207IHNrYWxsdXJ1QG1hcnZlbGwuY29tOw0KPiBybW9keUBtYXJ2ZWxsLmNvbTsga3lzQG1p
Y3Jvc29mdC5jb207IGhhaXlhbmd6QG1pY3Jvc29mdC5jb207DQo+IHN0aGVtbWluQG1pY3Jvc29m
dC5jb207IHdlaS5saXVAa2VybmVsLm9yZzsgbXN0QHJlZGhhdC5jb207DQo+IGphc293YW5nQHJl
ZGhhdC5jb207IHB2LWRyaXZlcnNAdm13YXJlLmNvbTsgZG9zaGlyQHZtd2FyZS5jb207DQo+IGFs
ZXhhbmRlcmR1eWNrQGZiLmNvbTsgS2VybmVsLXRlYW1AZmIuY29tDQo+IFN1YmplY3Q6IFtFWFRF
Uk5BTF0gW25ldC1uZXh0IFBBVENIIDA1LzEwXSBlbmE6IFVwZGF0ZSBkcml2ZXIgdG8gdXNlDQo+
IGV0aHRvb2xfc3ByaW50Zg0KPiANCj4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXJk
dXlja0BmYi5jb20+DQo+IA0KPiBSZXBsYWNlIGluc3RhbmNlcyBvZiBzbnByaW50ZiBvciBtZW1j
cHkgd2l0aCBhIHBvaW50ZXIgdXBkYXRlIHdpdGgNCj4gZXRodG9vbF9zcHJpbnRmLg0KPiANCj4g
QWNrZWQtYnk6IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyZHV5Y2tAZmIuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYyB8ICAgMjUg
KysrKysrKysrKystLS0tLS0tDQo+IC0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNl
cnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkNCj4gDQpBY2tlZC1ieTogQXJ0aHVyIEtpeWFub3Zz
a2kgPGFraXlhbm9AYW1hem9uLmNvbT4NCg==
