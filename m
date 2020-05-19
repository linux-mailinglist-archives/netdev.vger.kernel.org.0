Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E06B1DA5AC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgESXg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:36:26 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:60301 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgESXgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589931385; x=1621467385;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=0h+Ql3kIm4ll7H2x0wPz8bL2x8DkfsmOA0XR/gfEPpY=;
  b=PA0WHi9a1pXITQUUnk2ahZnIEkbGdTpTqmQBDre65zpPSqrs8cj4Z5tQ
   bm0WWZqR3dWuG1pjDNKH5oeQD5IOFqhh/hTIS76GFoZWM5G59RAo9WqwY
   8iDf5CjsFJAw6peHKPOa/ajgiRgVntKw083xi5Kw7U2fT0rxTlBkOGaL9
   g=;
IronPort-SDR: Sh8oCgbi6ol5SpCMMV88N8TUDQi1X1SmJ82frou2UB9gXc2YCfQwJsx4ulZpnJZdnAgU8Z+Lwj
 +kWTUjNdOG8g==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="45951027"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 May 2020 23:36:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 14090A20B8;
        Tue, 19 May 2020 23:36:15 +0000 (UTC)
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:36:15 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13d01UWB002.ant.amazon.com (10.43.161.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:36:15 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1497.006;
 Tue, 19 May 2020 23:36:15 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     "Singh, Balbir" <sblbir@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH 05/12] genirq: Shutdown irq chips in suspend/resume during
 hibernation
Thread-Topic: [PATCH 05/12] genirq: Shutdown irq chips in suspend/resume
 during hibernation
Thread-Index: AQHWLjMagtxHeVJBCkiD+MEoaDFA5aiwDkSA//+Mf4A=
Date:   Tue, 19 May 2020 23:36:14 +0000
Message-ID: <18B5CBBA-FF9E-4DBF-8631-EE9AF4925861@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <fce013fc1348f02b8e4ec61e7a631093c72f993c.1589926004.git.anchalag@amazon.com>
 <d489ede4d70ae22a601ee0afc92bda936baa8b11.camel@amazon.com>
In-Reply-To: <d489ede4d70ae22a601ee0afc92bda936baa8b11.camel@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.193]
Content-Type: text/plain; charset="utf-8"
Content-ID: <997D8B2104EB634CAA6BF7D36DEE734D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzLiBMb29rcyBsaWtlIHNlbmQgYW4gb2xkIG9uZSB3aXRob3V0IGZpeC4gRGlkIHJlc2Vu
ZCB0aGUgcGF0Y2ggYWdhaW4uDQoNCu+7vyAgICBPbiBUdWUsIDIwMjAtMDUtMTkgYXQgMjM6MjYg
KzAwMDAsIEFuY2hhbCBBZ2Fyd2FsIHdyb3RlOg0KICAgID4gU2lnbmVkLW9mZi0tYnk6IFRob21h
cyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPg0KDQogICAgVGhlIFNpZ25lZC1vZmYtYnkg
bGluZSBuZWVkcyB0byBiZSBmaXhlZCAoaGludDogeW91IGhhdmUgLS0pDQoNCiAgICBCYWxiaXIg
U2luZ2gNCg0KDQo=
