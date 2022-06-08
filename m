Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0E542621
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiFHD4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiFHDzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:55:14 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 9C5A223A021;
        Tue,  7 Jun 2022 18:03:14 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Wed, 8 Jun 2022 09:02:10
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.78.144]
Date:   Wed, 8 Jun 2022 09:02:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, jreuter@yaina.de,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-hams@vger.kernel.org, thomas@osterried.de
Subject: Re: [PATCH v2] net: ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CANn89iJoOvG=KrouTpe+bgAVf=mYtxE1D3m542UF96XwxKEVsQ@mail.gmail.com>
References: <20220607142337.78458-1-duoming@zju.edu.cn>
 <CANn89iJoOvG=KrouTpe+bgAVf=mYtxE1D3m542UF96XwxKEVsQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3c463bfd.58476.18140d5501a.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDHa7gS9Z9itGG0AQ--.38641W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsPAVZdtaGKPwAAst
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUdWUsIDcgSnVuIDIwMjIgMTA6MDY6MjcgLTA3MDAgRXJpYyBEdW1hemV0IHdy
b3RlOgoKPiBPbiBUdWUsIEp1biA3LCAyMDIyIGF0IDc6MjQgQU0gRHVvbWluZyBaaG91IDxkdW9t
aW5nQHpqdS5lZHUuY24+IHdyb3RlOgo+ID4KPiA+IFRoZSBza2JfcmVjdl9kYXRhZ3JhbSgpIGlu
IGF4MjVfcmVjdm1zZygpIHdpbGwgaG9sZCBsb2NrX3NvY2sKPiA+IGFuZCBibG9jayB1bnRpbCBp
dCByZWNlaXZlcyBhIHBhY2tldCBmcm9tIHRoZSByZW1vdGUuIElmIHRoZSBjbGllbnQKPiA+IGRv
ZXNuYHQgY29ubmVjdCB0byBzZXJ2ZXIgYW5kIGNhbGxzIHJlYWQoKSBkaXJlY3RseSwgaXQgd2ls
bCBub3QKPiA+IHJlY2VpdmUgYW55IHBhY2tldHMgZm9yZXZlci4gQXMgYSByZXN1bHQsIHRoZSBk
ZWFkbG9jayB3aWxsIGhhcHBlbi4KPiA+Cj4gPiBUaGUgZmFpbCBsb2cgY2F1c2VkIGJ5IGRlYWRs
b2NrIGlzIHNob3duIGJlbG93Ogo+ID4KPiA+IFsgIDM2OS42MDY5NzNdIElORk86IHRhc2sgYXgy
NV9kZWFkbG9jazoxNTcgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDI0NSBzZWNvbmRzLgo+ID4gWyAg
MzY5LjYwODkxOV0gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRf
c2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgo+ID4gWyAgMzY5LjYxMzA1OF0gQ2FsbCBUcmFj
ZToKPiA+IFsgIDM2OS42MTMzMTVdICA8VEFTSz4KPiA+IFsgIDM2OS42MTQwNzJdICBfX3NjaGVk
dWxlKzB4MmY5LzB4YjIwCj4gPiBbICAzNjkuNjE1MDI5XSAgc2NoZWR1bGUrMHg0OS8weGIwCj4g
PiBbICAzNjkuNjE1NzM0XSAgX19sb2NrX3NvY2srMHg5Mi8weDEwMAo+ID4gWyAgMzY5LjYxNjc2
M10gID8gZGVzdHJveV9zY2hlZF9kb21haW5zX3JjdSsweDIwLzB4MjAKPiA+IFsgIDM2OS42MTc5
NDFdICBsb2NrX3NvY2tfbmVzdGVkKzB4NmUvMHg3MAo+ID4gWyAgMzY5LjYxODgwOV0gIGF4MjVf
YmluZCsweGFhLzB4MjEwCj4gPiBbICAzNjkuNjE5NzM2XSAgX19zeXNfYmluZCsweGNhLzB4ZjAK
PiA+IFsgIDM2OS42MjAwMzldICA/IGRvX2Z1dGV4KzB4YWUvMHgxYjAKPiA+IFsgIDM2OS42MjAz
ODddICA/IF9feDY0X3N5c19mdXRleCsweDdjLzB4MWMwCj4gPiBbICAzNjkuNjIwNjAxXSAgPyBm
cHJlZ3NfYXNzZXJ0X3N0YXRlX2NvbnNpc3RlbnQrMHgxOS8weDQwCj4gPiBbICAzNjkuNjIwNjEz
XSAgX194NjRfc3lzX2JpbmQrMHgxMS8weDIwCj4gPiBbICAzNjkuNjIxNzkxXSAgZG9fc3lzY2Fs
bF82NCsweDNiLzB4OTAKPiA+IFsgIDM2OS42MjI0MjNdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVy
X2h3ZnJhbWUrMHg0Ni8weGIwCj4gPiBbICAzNjkuNjIzMzE5XSBSSVA6IDAwMzM6MHg3ZjQzYzhh
YThhZjcKPiA+IFsgIDM2OS42MjQzMDFdIFJTUDogMDAyYjowMDAwN2Y0M2M4MTk3ZWY4IEVGTEFH
UzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwMzEKPiA+IFsgIDM2OS42MjU3NTZd
IFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwN2Y0
M2M4YWE4YWY3Cj4gPiBbICAzNjkuNjI2NzI0XSBSRFg6IDAwMDAwMDAwMDAwMDAwMTAgUlNJOiAw
MDAwNTU3NjhlMjAyMWQwIFJESTogMDAwMDAwMDAwMDAwMDAwNQo+ID4gWyAgMzY5LjYyODU2OV0g
UkJQOiAwMDAwN2Y0M2M4MTk3ZjAwIFIwODogMDAwMDAwMDAwMDAwMDAxMSBSMDk6IDAwMDA3ZjQz
YzgxOTg3MDAKPiA+IFsgIDM2OS42MzAyMDhdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAw
MDAwMDAwMDAwMDAyNDYgUjEyOiAwMDAwN2ZmZjg0NWU2YWZlCj4gPiBbICAzNjkuNjMyMjQwXSBS
MTM6IDAwMDA3ZmZmODQ1ZTZhZmYgUjE0OiAwMDAwN2Y0M2M4MTk3ZmMwIFIxNTogMDAwMDdmNDNj
ODE5ODcwMAo+ID4KPiA+IFRoaXMgcGF0Y2ggbW92ZXMgdGhlIHNrYl9yZWN2X2RhdGFncmFtKCkg
YmVmb3JlIGxvY2tfc29jaygpIGluIG9yZGVyCj4gPiB0aGF0IG90aGVyIGZ1bmN0aW9ucyB0aGF0
IG5lZWQgbG9ja19zb2NrIGNvdWxkIGJlIGV4ZWN1dGVkLgo+ID4KPiA+IFN1Z2dlc3RlZC1ieTog
VGhvbWFzIE9zdGVycmllZCA8dGhvbWFzQG9zdGVycmllZC5kZT4KPiA+IFNpZ25lZC1vZmYtYnk6
IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+ID4gUmVwb3J0ZWQtYnk6IFRob21h
cyBIYWJldHMgPHRob21hc0BAaGFiZXRzLnNlPgo+ID4gLS0tCj4gPiBDaGFuZ2VzIGluIHYyOgo+
ID4gICAtIE1ha2UgY29tbWl0IG1lc3NhZ2VzIGNsZWFyZXIuCj4gPgo+ID4gIG5ldC9heDI1L2Fm
X2F4MjUuYyB8IDExICsrKysrKy0tLS0tCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkKPiA+Cj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2F4MjUvYWZfYXgy
NS5jIGIvbmV0L2F4MjUvYWZfYXgyNS5jCj4gPiBpbmRleCA5NTM5M2JiMjc2MC4uMDJjZDYwODc1
MTIgMTAwNjQ0Cj4gPiAtLS0gYS9uZXQvYXgyNS9hZl9heDI1LmMKPiA+ICsrKyBiL25ldC9heDI1
L2FmX2F4MjUuYwo+ID4gQEAgLTE2NjUsNiArMTY2NSwxMSBAQCBzdGF0aWMgaW50IGF4MjVfcmVj
dm1zZyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBzaXpl
LAo+ID4gICAgICAgICBpbnQgY29waWVkOwo+ID4gICAgICAgICBpbnQgZXJyID0gMDsKPiA+Cj4g
PiArICAgICAgIC8qIE5vdyB3ZSBjYW4gdHJlYXQgYWxsIGFsaWtlICovCj4gPiArICAgICAgIHNr
YiA9IHNrYl9yZWN2X2RhdGFncmFtKHNrLCBmbGFncywgJmVycik7Cj4gPiArICAgICAgIGlmICgh
c2tiKQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZG9uZTsKPiA+ICsKPiAKPiBTbyBhdCB0aGlz
IHBvaW50IHdlIGhhdmUgc2tiPXNvbWV0aGluZy4gVGhpcyBtZWFucyB0aGF0IHRoZSBmb2xsb3dp
bmcKPiBicmFuY2ggd2lsbCBsZWFrIGl0Lgo+IAo+IGlmIChzay0+c2tfdHlwZSA9PSBTT0NLX1NF
UVBBQ0tFVCAmJiBzay0+c2tfc3RhdGUgIT0gVENQX0VTVEFCTElTSEVEKSB7Cj4gICAgIGVyciA9
ICAtRU5PVENPTk47Cj4gICAgIGdvdG8gb3V0OyAgICAvLyBza2Igd2lsbCBiZSBsZWFrZWQKPiB9
Cj4gCgpUaGFuayB5b3VyIGZvciBwb2ludGluZyBvdXQgdGhlIHByb2JsZW0hCkkgd2lsbCBhZGQg
c2tiX2ZyZWVfZGF0YWdyYW0oKSBiZWZvcmUgZ290byBvdXQgaW4gb3JkZXIgdG8gbWl0aWdhdGUg
dGhlIG1lbW9yeSBsZWFrLgoKICAgICAgICBpZiAoc2stPnNrX3R5cGUgPT0gU09DS19TRVFQQUNL
RVQgJiYgc2stPnNrX3N0YXRlICE9IFRDUF9FU1RBQkxJU0hFRCkgewogICAgICAgICAgICAgICAg
ZXJyID0gIC1FTk9UQ09OTjsKKyAgICAgICAgICAgICAgIHNrYl9mcmVlX2RhdGFncmFtKHNrLCBz
a2IpOwogICAgICAgICAgICAgICAgZ290byBvdXQ7CiAgICAgICAgfQoKQmVzdCByZWdhcmRzLApE
dW9taW5nIFpob3UKCg==
