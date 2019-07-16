Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD18B6ABA5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfGPPYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 11:24:37 -0400
Received: from LLMX2.LL.MIT.EDU ([129.55.12.48]:38500 "EHLO llmx2.ll.mit.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfGPPYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 11:24:37 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2019 11:24:37 EDT
Received: from LLE2K16-MBX02.mitll.ad.local (LLE2K16-MBX02.mitll.ad.local) by llmx2.ll.mit.edu (unknown) with ESMTPS id x6GFDIXn004512; Tue, 16 Jul 2019 11:13:18 -0400
From:   "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Dustin Marquess" <dmarquess@apple.com>
Subject: RE: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Topic: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Thread-Index: AQKw2gvaIH+7kp/NrCmbg6L94CyO5gHbs90WAiPXn9kCN14y2gIOoPmspMqxmMCAAEuhgP//vbsQgABSeoCAASdFwIAHs2Eg
Date:   Tue, 16 Jul 2019 15:13:15 +0000
Message-ID: <23c64fbdcdb14517a01afaecc370a914@ll.mit.edu>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
In-Reply-To: <adec774ed16540c6b627c2f607f3e216@ll.mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.1.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xMS8yMDE5IDExOjE1IFBNLCBQcm91dCwgQW5kcmV3IC0gTExTQyAtIE1JVExMIHdyb3Rl
OiANCj4gSSBpbiBubyB3YXkgaW50ZW5kZWQgdG8gaW1wbHkgdGhhdCBJIGhhZCBjb25maXJtZWQg
dGhlIHNtYWxsIFNPX1NOREJVRiB3YXMgYSBwcmVyZXF1aXNpdGUgdG8gb3VyIHByb2JsZW0uIFdp
dGggbXkgc3ludGhldGljIHRlc3QsIEkgd2FzIGxvb2tpbmcgZm9yIGEgY29uY2lzZSByZXByb2R1
Y2VyIGFuZCB0cnlpbmcgdGhpbmdzIHRvID4gc3RyZXNzIHRoZSBzeXN0ZW0uDQoNCkkndmUgbG9v
a2VkIGludG8gdGhpcyBzb21lIG1vcmU6IEkgYW0gbm93IGFibGUgdG8gcmVwcm9kdWNlIGl0IGNv
bnNpc3RlbnRseSAob24gNC4xNC4xMzIpIHdpdGggbXkgc3ludGhldGljIHRlc3Qgc2VlbWluZ2x5
IHJlZ2FyZGxlc3Mgb2YgdGhlIFNPX1NOREJVRiBzaXplICh0ZXN0ZWQgMTI4S2lCLCA1MTJLaUIs
IDFNaUIgYW5kIDEwTWlCKS4gVGhlIGtleSBjaGFuZ2UgdG8gbWFrZSBpdCByZXByb2R1Y2libGUg
d2FzIHRvIHVzZSBzZW5kZmlsZSgpIGluc3RlYWQgb2Ygc2VuZCgpIC0gdGhpcyBpcyB3aGF0IHNh
bWJhIHdhcyBkb2luZyBpbiBvdXIgcmVhbCBmYWlsdXJlIGNhc2UuIExvb2tpbmcgYXQgdGhlIGNv
ZGUsIGl0IGFwcGVhcnMgdGhhdCBzZW5kZmlsZSgpIGNhbGxzIGludG8gdGhlIHplcm9jb3B5IGZ1
bmN0aW9ucyB3aGljaCBvbmx5IGNoZWNrIFNOREJVRiBmb3IgbWVtb3J5IHRoZXkgYWxsb2NhdGUg
KHRoZSBza2Igc3RydWN0dXJlKSAtIHRoZXknbGwgaGFwcGlseSAib3ZlcmZpbGwiIHRoZSBzZW5k
IGJ1ZmZlciB3aXRoIHplcm9jb3B5J2QgcGFnZXMuDQoNCkluIG15IHRlc3RzIEkgY2FuIHNlZSB0
aGUgc2VuZCBidWZmZXIgdXNlZCByZXBvcnRlZCBieSBuZXRzdGF0IGdldHRpbmcgdG8gbXVjaCBs
YXJnZXIgdmFsdWVzIHRoYW4gdGhlIFNPX1NOREJVRiB2YWx1ZSBJIHNldCAod2l0aCBhIDEwTWlC
IFNPX1NOREJVRiwgaXQgZ290IHVwIHRvIH41Mk1pQiBvbiBhIHN0YWxsZWQgY29ubmVjdGlvbiku
IFRoaXMgb2YgY291cnNlIGVhc2lseSBjYXVzZXMgdGhlIENWRS0yMDE5LTExNDc4IGZpeCB0byBm
YWxzZSBhbGFybSBhbmQgdGhlIFRDUCBjb25uZWN0aW9uIHRvIHN0YWxsLg0K
