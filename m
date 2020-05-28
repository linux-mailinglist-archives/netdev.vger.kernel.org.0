Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8D31E68F4
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405689AbgE1SAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:00:10 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31187 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405660AbgE1SAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590688806; x=1622224806;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=oNLZyUl66SSao9Xw7N5boBOPLPGR9xPVVpFRzGyK3NE=;
  b=s43+FZ8Nz7kZbtJperGPcMOuVZQdzrpN3OXb3G6Oh8IxBFS/d0txTVGj
   O7B359ro3OopCvJYCugnmdDztIGiQDLsM++TyyA5WGMChwI8wCkUEWGj8
   1Yeey6KTRKCYyenGtMcWpmFOjkiw1BEnflsFxR/Qa7QshpJ+ebLo3a4Bh
   w=;
IronPort-SDR: DwLXL+vYnHFAOhYL+bAJq2wvFGMWzlfLyvOlliswhA0S5m+T3cKSKThAFDRaimJS+sGp4RwSS/
 uPgnrdWwGcFA==
X-IronPort-AV: E=Sophos;i="5.73,445,1583193600"; 
   d="scan'208";a="46991822"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 May 2020 18:00:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 772142849E5;
        Thu, 28 May 2020 17:59:53 +0000 (UTC)
Received: from EX13D10UWB002.ant.amazon.com (10.43.161.130) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 17:59:52 +0000
Received: from EX13D07UWB002.ant.amazon.com (10.43.161.131) by
 EX13D10UWB002.ant.amazon.com (10.43.161.130) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 17:59:52 +0000
Received: from EX13D07UWB002.ant.amazon.com ([10.43.161.131]) by
 EX13D07UWB002.ant.amazon.com ([10.43.161.131]) with mapi id 15.00.1497.006;
 Thu, 28 May 2020 17:59:52 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 00/12] Fix PM hibernation in Xen guests
Thread-Topic: [PATCH 00/12] Fix PM hibernation in Xen guests
Thread-Index: AQHWLiw8BReG6kpgjke8dS/vAeapjqi9Yd+A
Date:   Thu, 28 May 2020 17:59:52 +0000
Message-ID: <0C3CEAD6-E79C-490E-8FEA-2276E87BD7B4@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
In-Reply-To: <cover.1589926004.git.anchalag@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <20D843639614D14FA2EFCF8BE29971CC@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSBnZW50bGUgcGluZyBvbiB0aGlzIHdob2xlIHBhdGNoIHNlcmllcy4NCg0KVGhhbmtzLA0KQW5j
aGFsDQoNCu+7vyAgICBIZWxsbywNCiAgICBUaGlzIHNlcmllcyBmaXhlcyBQTSBoaWJlcm5hdGlv
biBmb3IgaHZtIGd1ZXN0cyBydW5uaW5nIG9uIHhlbiBoeXBlcnZpc29yLg0KICAgIFRoZSBydW5u
aW5nIGd1ZXN0IGNvdWxkIG5vdyBiZSBoaWJlcm5hdGVkIGFuZCByZXN1bWVkIHN1Y2Nlc3NmdWxs
eSBhdCBhDQogICAgbGF0ZXIgdGltZS4gVGhlIGZpeGVzIGZvciBQTSBoaWJlcm5hdGlvbiBhcmUg
YWRkZWQgdG8gYmxvY2sgYW5kDQogICAgbmV0d29yayBkZXZpY2UgZHJpdmVycyBpLmUgeGVuLWJs
a2Zyb250IGFuZCB4ZW4tbmV0ZnJvbnQuIEFueSBvdGhlciBkcml2ZXINCiAgICB0aGF0IG5lZWRz
IHRvIGFkZCBTNCBzdXBwb3J0IGlmIG5vdCBhbHJlYWR5LCBjYW4gZm9sbG93IHNhbWUgbWV0aG9k
IG9mDQogICAgaW50cm9kdWNpbmcgZnJlZXplL3RoYXcvcmVzdG9yZSBjYWxsYmFja3MuDQogICAg
VGhlIHBhdGNoZXMgaGFkIGJlZW4gdGVzdGVkIGFnYWluc3QgdXBzdHJlYW0ga2VybmVsIGFuZCB4
ZW40LjExLiBMYXJnZQ0KICAgIHNjYWxlIHRlc3RpbmcgaXMgYWxzbyBkb25lIG9uIFhlbiBiYXNl
ZCBBbWF6b24gRUMyIGluc3RhbmNlcy4gQWxsIHRoaXMgdGVzdGluZw0KICAgIGludm9sdmVkIHJ1
bm5pbmcgbWVtb3J5IGV4aGF1c3Rpbmcgd29ya2xvYWQgaW4gdGhlIGJhY2tncm91bmQuDQoNCiAg
ICBEb2luZyBndWVzdCBoaWJlcm5hdGlvbiBkb2VzIG5vdCBpbnZvbHZlIGFueSBzdXBwb3J0IGZy
b20gaHlwZXJ2aXNvciBhbmQNCiAgICB0aGlzIHdheSBndWVzdCBoYXMgY29tcGxldGUgY29udHJv
bCBvdmVyIGl0cyBzdGF0ZS4gSW5mcmFzdHJ1Y3R1cmUNCiAgICByZXN0cmljdGlvbnMgZm9yIHNh
dmluZyB1cCBndWVzdCBzdGF0ZSBjYW4gYmUgb3ZlcmNvbWUgYnkgZ3Vlc3QgaW5pdGlhdGVkDQog
ICAgaGliZXJuYXRpb24uDQoNCiAgICBUaGVzZSBwYXRjaGVzIHdlcmUgc2VuZCBvdXQgYXMgUkZD
IGJlZm9yZSBhbmQgYWxsIHRoZSBmZWVkYmFjayBoYWQgYmVlbg0KICAgIGluY29ycG9yYXRlZCBp
biB0aGUgcGF0Y2hlcy4gVGhlIGxhc3QgUkZDVjMgY291bGQgYmUgZm91bmQgaGVyZToNCiAgICBo
dHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC8yLzE0LzI3ODkNCg0KICAgIEtub3duIGlzc3VlczoN
CiAgICAxLktBU0xSIGNhdXNlcyBpbnRlcm1pdHRlbnQgaGliZXJuYXRpb24gZmFpbHVyZXMuIFZN
IGZhaWxzIHRvIHJlc3VtZXMgYW5kDQogICAgaGFzIHRvIGJlIHJlc3RhcnRlZC4gSSB3aWxsIGlu
dmVzdGlnYXRlIHRoaXMgaXNzdWUgc2VwYXJhdGVseSBhbmQgc2hvdWxkbid0DQogICAgYmUgYSBi
bG9ja2VyIGZvciB0aGlzIHBhdGNoIHNlcmllcy4NCiAgICAyLiBEdXJpbmcgaGliZXJuYXRpb24s
IEkgb2JzZXJ2ZWQgc29tZXRpbWVzIHRoYXQgZnJlZXppbmcgb2YgdGFza3MgZmFpbHMgZHVlDQog
ICAgdG8gYnVzeSBYRlMgd29ya3F1ZXVlaVt4ZnMtY2lsL3hmcy1zeW5jXS4gVGhpcyBpcyBhbHNv
IGludGVybWl0dGVudCBtYXkgYmUgMQ0KICAgIG91dCBvZiAyMDAgcnVucyBhbmQgaGliZXJuYXRp
b24gaXMgYWJvcnRlZCBpbiB0aGlzIGNhc2UuIFJlLXRyeWluZyBoaWJlcm5hdGlvbg0KICAgIG1h
eSB3b3JrLiBBbHNvLCB0aGlzIGlzIGEga25vd24gaXNzdWUgd2l0aCBoaWJlcm5hdGlvbiBhbmQg
c29tZQ0KICAgIGZpbGVzeXN0ZW1zIGxpa2UgWEZTIGhhcyBiZWVuIGRpc2N1c3NlZCBieSB0aGUg
Y29tbXVuaXR5IGZvciB5ZWFycyB3aXRoIG5vdCBhbg0KICAgIGVmZmVjdHZlIHJlc29sdXRpb24g
YXQgdGhpcyBwb2ludC4NCg0KICAgIFRlc3RpbmcgSG93IHRvOg0KICAgIC0tLS0tLS0tLS0tLS0t
LQ0KICAgIDEuIFNldHVwIHhlbiBoeXBlcnZpc29yIG9uIGEgcGh5c2ljYWwgbWFjaGluZVsgSSB1
c2VkIFVidW50dSAxNi4wNCArdXBzdHJlYW0NCiAgICB4ZW4tNC4xMV0NCiAgICAyLiBCcmluZyB1
cCBhIEhWTSBndWVzdCB3L3Qga2VybmVsIGNvbXBpbGVkIHdpdGggaGliZXJuYXRpb24gcGF0Y2hl
cw0KICAgIFtJIHVzZWQgdWJ1bnR1MTguMDQgbmV0Ym9vdCBiaW9uaWMgaW1hZ2VzIGFuZCBhbHNv
IEFtYXpvbiBMaW51eCBvbi1wcmVtIGltYWdlc10uDQogICAgMy4gQ3JlYXRlIGEgc3dhcCBmaWxl
IHNpemU9UkFNIHNpemUNCiAgICA0LiBVcGRhdGUgZ3J1YiBwYXJhbWV0ZXJzIGFuZCByZWJvb3QN
CiAgICA1LiBUcmlnZ2VyIHBtLWhpYmVybmF0aW9uIGZyb20gd2l0aGluIHRoZSBWTQ0KDQogICAg
RXhhbXBsZToNCiAgICBTZXQgdXAgYSBmaWxlLWJhY2tlZCBzd2FwIHNwYWNlLiBTd2FwIGZpbGUg
c2l6ZT49VG90YWwgbWVtb3J5IG9uIHRoZSBzeXN0ZW0NCiAgICBzdWRvIGRkIGlmPS9kZXYvemVy
byBvZj0vc3dhcCBicz0kKCggMTAyNCAqIDEwMjQgKSkgY291bnQ9NDA5NiAjIDQwOTZNaUINCiAg
ICBzdWRvIGNobW9kIDYwMCAvc3dhcA0KICAgIHN1ZG8gbWtzd2FwIC9zd2FwDQogICAgc3VkbyBz
d2Fwb24gL3N3YXANCg0KICAgIFVwZGF0ZSByZXN1bWUgZGV2aWNlL3Jlc3VtZSBvZmZzZXQgaW4g
Z3J1YiBpZiB1c2luZyBzd2FwIGZpbGU6DQogICAgcmVzdW1lPS9kZXYveHZkYTEgcmVzdW1lX29m
ZnNldD0yMDA3MDQgbm9fY29uc29sZV9zdXNwZW5kPTENCg0KICAgIEV4ZWN1dGU6DQogICAgLS0t
LS0tLS0NCiAgICBzdWRvIHBtLWhpYmVybmF0ZQ0KICAgIE9SDQogICAgZWNobyBkaXNrID4gL3N5
cy9wb3dlci9zdGF0ZSAmJiBlY2hvIHJlYm9vdCA+IC9zeXMvcG93ZXIvZGlzaw0KDQogICAgQ29t
cHV0ZSByZXN1bWUgb2Zmc2V0IGNvZGU6DQogICAgIg0KICAgICMhL3Vzci9iaW4vZW52IHB5dGhv
bg0KICAgIGltcG9ydCBzeXMNCiAgICBpbXBvcnQgYXJyYXkNCiAgICBpbXBvcnQgZmNudGwNCg0K
ICAgICNzd2FwIGZpbGUNCiAgICBmID0gb3BlbihzeXMuYXJndlsxXSwgJ3InKQ0KICAgIGJ1ZiA9
IGFycmF5LmFycmF5KCdMJywgWzBdKQ0KDQogICAgI0ZJQk1BUA0KICAgIHJldCA9IGZjbnRsLmlv
Y3RsKGYuZmlsZW5vKCksIDB4MDEsIGJ1ZikNCiAgICBwcmludCBidWZbMF0NCiAgICAiDQoNCg0K
ICAgIEFuY2hhbCBBZ2Fyd2FsICg1KToNCiAgICAgIHg4Ni94ZW46IEludHJvZHVjZSBuZXcgZnVu
Y3Rpb24gdG8gbWFwIEhZUEVSVklTT1Jfc2hhcmVkX2luZm8gb24NCiAgICAgICAgUmVzdW1lDQog
ICAgICBnZW5pcnE6IFNodXRkb3duIGlycSBjaGlwcyBpbiBzdXNwZW5kL3Jlc3VtZSBkdXJpbmcg
aGliZXJuYXRpb24NCiAgICAgIHhlbjogSW50cm9kdWNlIHdyYXBwZXIgZm9yIHNhdmUvcmVzdG9y
ZSBzY2hlZCBjbG9jayBvZmZzZXQNCiAgICAgIHhlbjogVXBkYXRlIHNjaGVkIGNsb2NrIG9mZnNl
dCB0byBhdm9pZCBzeXN0ZW0gaW5zdGFiaWxpdHkgaW4NCiAgICAgICAgaGliZXJuYXRpb24NCiAg
ICAgIFBNIC8gaGliZXJuYXRlOiB1cGRhdGUgdGhlIHJlc3VtZSBvZmZzZXQgb24gU05BUFNIT1Rf
U0VUX1NXQVBfQVJFQQ0KDQogICAgTXVuZWhpc2EgS2FtYXRhICg3KToNCiAgICAgIHhlbi9tYW5h
Z2U6IGtlZXAgdHJhY2sgb2YgdGhlIG9uLWdvaW5nIHN1c3BlbmQgbW9kZQ0KICAgICAgeGVuYnVz
OiBhZGQgZnJlZXplL3RoYXcvcmVzdG9yZSBjYWxsYmFja3Mgc3VwcG9ydA0KICAgICAgeDg2L3hl
bjogYWRkIHN5c3RlbSBjb3JlIHN1c3BlbmQgYW5kIHJlc3VtZSBjYWxsYmFja3MNCiAgICAgIHhl
bi1ibGtmcm9udDogYWRkIGNhbGxiYWNrcyBmb3IgUE0gc3VzcGVuZCBhbmQgaGliZXJuYXRpb24N
CiAgICAgIHhlbi1uZXRmcm9udDogYWRkIGNhbGxiYWNrcyBmb3IgUE0gc3VzcGVuZCBhbmQgaGli
ZXJuYXRpb24NCiAgICAgIHhlbi90aW1lOiBpbnRyb2R1Y2UgeGVuX3tzYXZlLHJlc3RvcmV9X3N0
ZWFsX2Nsb2NrDQogICAgICB4ODYveGVuOiBzYXZlIGFuZCByZXN0b3JlIHN0ZWFsIGNsb2NrDQoN
CiAgICAgYXJjaC94ODYveGVuL2VubGlnaHRlbl9odm0uYyAgICAgIHwgICA4ICsrDQogICAgIGFy
Y2gveDg2L3hlbi9zdXNwZW5kLmMgICAgICAgICAgICB8ICA3MiArKysrKysrKysrKysrKysrKysN
CiAgICAgYXJjaC94ODYveGVuL3RpbWUuYyAgICAgICAgICAgICAgIHwgIDE4ICsrKystDQogICAg
IGFyY2gveDg2L3hlbi94ZW4tb3BzLmggICAgICAgICAgICB8ICAgMyArDQogICAgIGRyaXZlcnMv
YmxvY2sveGVuLWJsa2Zyb250LmMgICAgICB8IDEyMiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0NCiAgICAgZHJpdmVycy9uZXQveGVuLW5ldGZyb250LmMgICAgICAgIHwgIDk4ICsrKysr
KysrKysrKysrKysrKysrKysrLQ0KICAgICBkcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRzX2Jhc2Uu
YyAgfCAgIDEgKw0KICAgICBkcml2ZXJzL3hlbi9tYW5hZ2UuYyAgICAgICAgICAgICAgfCAgNzMg
KysrKysrKysrKysrKysrKysrDQogICAgIGRyaXZlcnMveGVuL3RpbWUuYyAgICAgICAgICAgICAg
ICB8ICAyOSArKysrKystDQogICAgIGRyaXZlcnMveGVuL3hlbmJ1cy94ZW5idXNfcHJvYmUuYyB8
ICA5OSArKysrKysrKysrKysrKysrKysrLS0tLS0NCiAgICAgaW5jbHVkZS9saW51eC9pcnEuaCAg
ICAgICAgICAgICAgIHwgICAyICsNCiAgICAgaW5jbHVkZS94ZW4veGVuLW9wcy5oICAgICAgICAg
ICAgIHwgICA4ICsrDQogICAgIGluY2x1ZGUveGVuL3hlbmJ1cy5oICAgICAgICAgICAgICB8ICAg
MyArDQogICAgIGtlcm5lbC9pcnEvY2hpcC5jICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KICAg
ICBrZXJuZWwvaXJxL2ludGVybmFscy5oICAgICAgICAgICAgfCAgIDEgKw0KICAgICBrZXJuZWwv
aXJxL3BtLmMgICAgICAgICAgICAgICAgICAgfCAgMzEgKysrKystLS0NCiAgICAga2VybmVsL3Bv
d2VyL3VzZXIuYyAgICAgICAgICAgICAgIHwgICA2ICstDQogICAgIDE3IGZpbGVzIGNoYW5nZWQs
IDUzNiBpbnNlcnRpb25zKCspLCA0MCBkZWxldGlvbnMoLSkNCg0KICAgIC0tIA0KICAgIDIuMjQu
MS5BTVpODQoNCg0K
