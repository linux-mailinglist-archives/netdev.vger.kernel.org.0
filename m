Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751885896D7
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 06:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbiHDERc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 00:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHDER3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 00:17:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302363FA0C
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 21:17:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id e13so4849957edj.12
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 21:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4mHygLe4KsW6UUzeqoymi1F4W/THMx9/uJZ7a897Fp8=;
        b=cy1AtVBWN0pdaq+LGKPf0QBumg7rpxIEz/njl4j/pXRRZ5Coh6CyF4SaVlR2qsfakO
         Hl9OWQWkUdCHn19C3E9U//kC7Ik6iMRzNo6ciNyWmFbf1LuWmyztnBVfibzRZZkJvYO3
         0M3Eyr2M5GoJmNarlwfYpuLli0sA1Yb37ukjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4mHygLe4KsW6UUzeqoymi1F4W/THMx9/uJZ7a897Fp8=;
        b=Ug8+KAdWvzJsuyvrpXC4WOj+lKrVnnxurDxnMlVSsjyo3Y4ZC7iIJ+DvxK9kGTa/xB
         dulQkdcD3HfVuLTnzlHuKmgnZwxuMARdzKrurp5Pa1qDYHOPM5jejP5O7ggYD1w9UDEG
         3RoD1WHDV6VcmnX1fjdiLkC3n4WLSucOxuEh3szsBoYQoInJwA7sNQ6HR6ftnk4yt/6c
         YCyJR59vpDv4MeyGMIhk47yDMPAekqcZOHA07nnzEufhtPUq22NOD/48IfgeN2sSaKZn
         45fERG6k+XwjRgqFCuph7hfFslP9SNZPSnUU0kNrQ6Blorhcb56TjCY6qqyzw1tW6shw
         Krsw==
X-Gm-Message-State: ACgBeo0C1ecyWOZgNb8TWjy7lZjQQzHEUuIZjD+ncXnEBSJAbQ8aUb0d
        3L2n75YoBv8Otq0k3Rd0CfV9lte7hK+5wmIK
X-Google-Smtp-Source: AA6agR41/UTyJj98q4+KbKDtDE4lyObzZnYZGw9ri5k7yUVW3BBGVLMfoHXrJAAXg77LLbArMS9BOg==
X-Received: by 2002:a05:6402:414b:b0:43b:6b1a:c230 with SMTP id x11-20020a056402414b00b0043b6b1ac230mr57499eda.42.1659586645427;
        Wed, 03 Aug 2022 21:17:25 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id kv26-20020a17090778da00b00730c4d1b1cesm508029ejc.178.2022.08.03.21.17.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 21:17:24 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id z17so19103968wrq.4
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 21:17:24 -0700 (PDT)
X-Received: by 2002:adf:edcb:0:b0:21e:d043:d271 with SMTP id
 v11-20020adfedcb000000b0021ed043d271mr32376wro.274.1659586643687; Wed, 03 Aug
 2022 21:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220803101438.24327-1-pabeni@redhat.com>
In-Reply-To: <20220803101438.24327-1-pabeni@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 21:17:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
Message-ID: <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
To:     Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005f466805e562a0cf"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005f466805e562a0cf
Content-Type: text/plain; charset="UTF-8"

Hmm. Another issue with the networking pull..

On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0
>
> Veerendranath Jakkam (5):
>       cfg80211: Indicate MLO connection info in connect and roam callbacks

This one added a

                for_each_valid_link(cr, link) {
                        if (WARN_ON_ONCE(!cr->links[link].bss))
                                break;
                }

in net/wireless/sme.c, and it seems to trigger on my brand new M2 Macbook Air.

Wireless still works fine (I'm writing this report on the machine),
but you get a scary splat:

  WARNING: CPU: 5 PID: 514 at net/wireless/sme.c:786
__cfg80211_connect_result+0x2fc/0x5c0 [cfg80211]

full call trace etc in the attachment.

               Linus

--0000000000005f466805e562a0cf
Content-Type: application/octet-stream; name=out
Content-Disposition: attachment; filename=out
Content-Transfer-Encoding: base64
Content-ID: <f_l6eizc1r0>
X-Attachment-Id: f_l6eizc1r0

ClsgICAgMy4wNDU1OTBdIGJyY21mbWFjOiBicmNtZl9jX3Byb2Nlc3NfdHhjYXBfYmxvYjogVHhD
YXAgYmxvYiBmb3VuZCwgbG9hZGluZwpbICAgIDMuMDQ5NDg2XSBicmNtZm1hYzogYnJjbWZfY19w
cm9jZXNzX2NhbF9ibG9iOiBDYWxpYnJhdGlvbiBibG9iIHByb3ZpZGVkIGJ5IHBsYXRmb3JtLCBs
b2FkaW5nClsgICAgMy4wNjIyOTNdIGJyY21mbWFjOiBicmNtZl9jX3ByZWluaXRfZGNtZHM6IEZp
cm13YXJlOiBCQ000Mzg3Lzcgd2wwOiBBcHIgIDYgMjAyMiAwNTo1NTo1NCB2ZXJzaW9uIDIwLjkw
LjQ1LjAuOC43LjExOCBGV0lEIDAxLWU3MTM4ZmYyClsgICAgMy4wOTQzMzldIGJyY21mbWFjIDAw
MDA6MDE6MDAuMCB3bHAxczBmMDogcmVuYW1lZCBmcm9tIHdsYW4wClsgICAgMy43NzI3NDldIGll
ZWU4MDIxMSBwaHkwOiBicmNtZl9wMnBfc2V0X2Zpcm13YXJlOiBmYWlsZWQgdG8gdXBkYXRlIGRl
dmljZSBhZGRyZXNzIHJldCAtNTIKWyAgICAzLjc3Mzg3OF0gaWVlZTgwMjExIHBoeTA6IGJyY21m
X3AycF9jcmVhdGVfcDJwZGV2OiBzZXQgcDJwX2Rpc2MgZXJyb3IKWyAgICAzLjc3Mzg4Nl0gaWVl
ZTgwMjExIHBoeTA6IGJyY21mX2NmZzgwMjExX2FkZF9pZmFjZTogYWRkIGlmYWNlIHAycC1kZXYt
d2xwMXMwZiB0eXBlIDEwIGZhaWxlZDogZXJyPS01MgpbICAgIDUuMzc4NjE0XSByZmtpbGw6IGlu
cHV0IGhhbmRsZXIgZGlzYWJsZWQKWyAgICA1Ljc5NjI3NV0gQmx1ZXRvb3RoOiBSRkNPTU0gVFRZ
IGxheWVyIGluaXRpYWxpemVkClsgICAgNS43OTYyODFdIEJsdWV0b290aDogUkZDT01NIHNvY2tl
dCBsYXllciBpbml0aWFsaXplZApbICAgIDUuNzk2Mjg0XSBCbHVldG9vdGg6IFJGQ09NTSB2ZXIg
MS4xMQpbICAgIDguNzgzNTI0XSByZmtpbGw6IGlucHV0IGhhbmRsZXIgZW5hYmxlZApbICAgIDku
MzE5ODY3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA5LjMxOTg3
MV0gV0FSTklORzogQ1BVOiA1IFBJRDogNTE0IGF0IG5ldC93aXJlbGVzcy9zbWUuYzo3ODYgX19j
Zmc4MDIxMV9jb25uZWN0X3Jlc3VsdCsweDJmYy8weDVjMCBbY2ZnODAyMTFdClsgICAgOS4zMTk4
ODZdIE1vZHVsZXMgbGlua2VkIGluOiBzbmRfc2VxX2R1bW15IHNuZF9ocnRpbWVyIHNuZF9zZXEg
c25kX3NlcV9kZXZpY2UgcmZjb21tIG5mdF9maWJfaW5ldCBuZnRfZmliX2lwdjQgbmZ0X2ZpYl9p
cHY2IG5mdF9maWIgbmZ0X3JlamVjdF9pbmV0IG5mX3JlamVjdF9pcHY2IG5mdF9yZWplY3QgbmZ0
X2N0IG5mdF9jaGFpbl9uYXQgbmZfbmF0IG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9k
ZWZyYWdfaXB2NCBpcF9zZXQgbmZfdGFibGVzIG5mbmV0bGluayBxcnRyIGJuZXAgam95ZGV2IGhp
ZF9tYWdpY21vdXNlIGhjaV9iY200Mzc3IGJyY21mbWFjIGJyY211dGlsIGJsdWV0b290aCBjZmc4
MDIxMSBlY2RoX2dlbmVyaWMgZWNjIHJma2lsbCBtYWNzbWNfaGlkIGhpZF9hcHBsZSBzbmRfc29j
X3RhczI3NjQgYXBwbGVfc29jX2NwdWZyZXEgc25kX3NvY19hcHBsZV9tY2Egc25kX3NvY19hcHBs
ZV9zaWxpY29uIHNuZF9zb2Nfc2ltcGxlX2NhcmRfdXRpbHMgenJhbSB4aGNpX3BsYXRfaGNkIHho
Y2lfaGNkIG52bWVtX3NwbWlfbWZkIG1hY3NtY19wb3dlciBydGNfbWFjc21jIG1hY3NtY19yZWJv
b3QgZG9ja2NoYW5uZWxfaGlkIHNpbXBsZV9tZmRfc3BtaSByZWdtYXBfc3BtaSB0cHM2NTk4eCB0
eXBlYyBwY2llX2FwcGxlIGR3YzMgcGNpX2hvc3RfY29tbW9uIG52bWVfYXBwbGUgYXBwbGVfZG9j
a2NoYW5uZWwgYXBwbGVfc2FydCB1ZGNfY29yZSBhcHBsZV9tYWlsYm94IHNwbWlfYXBwbGVfY29u
dHJvbGxlciBwaW5jdHJsX2FwcGxlX2dwaW8gY2xrX2FwcGxlX25jbyBhcHBsZV9hZG1hYyBhcHBs
ZV9kYXJ0IGkyY19hcHBsZSBidHJmcyByYWlkNl9wcSB6c3RkX2NvbXByZXNzIGlwNl90YWJsZXMg
cGtjczhfa2V5X3BhcnNlciBmdXNlClsgICAgOS4zMTk5MDldIENQVTogNSBQSUQ6IDUxNCBDb21t
OiBrd29ya2VyL3UxNjo4IFRhaW50ZWQ6IEcgUyAgICAgIFcgICAgICAgICAgNi4wLjAtcmMwLTA3
NDYzLWc4MmY1NGVkZjdhNDkgIzE1ClsgICAgOS4zMTk5MTFdIEhhcmR3YXJlIG5hbWU6IEFwcGxl
IE1hY0Jvb2sgQWlyICgxMy1pbmNoLCBNMiwgMjAyMikgKERUKQpbICAgIDkuMzE5OTExXSBXb3Jr
cXVldWU6IGNmZzgwMjExIGNmZzgwMjExX2V2ZW50X3dvcmsgW2NmZzgwMjExXQpbICAgIDkuMzE5
OTIxXSBwc3RhdGU6IDAwNDAwMDA5IChuemN2IGRhaWYgK1BBTiAtVUFPIC1UQ08gLURJVCAtU1NC
UyBCVFlQRT0tLSkKWyAgICA5LjMxOTkyM10gcGMgOiBfX2NmZzgwMjExX2Nvbm5lY3RfcmVzdWx0
KzB4MmZjLzB4NWMwIFtjZmc4MDIxMV0KWyAgICA5LjMxOTkzMV0gbHIgOiBfX2NmZzgwMjExX2Nv
bm5lY3RfcmVzdWx0KzB4MmU0LzB4NWMwIFtjZmc4MDIxMV0KWyAgICA5LjMxOTkzOV0gc3AgOiBm
ZmZmODAwMDA5ZDIzY2MwClsgICAgOS4zMTk5MzldIHgyOTogZmZmZjgwMDAwOWQyM2NjMCB4Mjg6
IDAwMDAwMDAwMDAwMDAwMDAgeDI3OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgOS4zMTk5NDFdIHgy
NjogZmZmZjgwMDAwOTE3NzAwMCB4MjU6IGRlYWQwMDAwMDAwMDAxMDAgeDI0OiBkZWFkMDAwMDAw
MDAwMTIyClsgICAgOS4zMTk5NDJdIHgyMzogZmZmZjgwMDAwOWQyM2QwOCB4MjI6IGZmZmYwMDAw
MGY3MzIwMDggeDIxOiBmZmZmMDAwMDRmZGM0YjcyClsgICAgOS4zMTk5NDNdIHgyMDogZmZmZjAw
MDAxMmY2OTAwMCB4MTk6IGZmZmYwMDAwNGZkYzQ4MTggeDE4OiBmZmZmMDAwMDFiMDYwZGIwClsg
ICAgOS4zMTk5NDRdIHgxNzogMDAwMDAwMDAwMDAwMDAwMCB4MTY6IDAwMDAwMDAwMDAwMDAwMDAg
eDE1OiBmZmZjMDA5YjAxMDVjMDA2ClsgICAgOS4zMTk5NDZdIHgxNDogMThmZmFhMDYxOGZmYWEz
MyB4MTM6IDAwMDAwMDAwMDAwMDAwMDAgeDEyOiBhMzNkMDExMWY0Y2MwMDAxClsgICAgOS4zMTk5
NDddIHgxMTogMDAwMGZmZmEwMDAwMDAyZiB4MTA6IDMyNjIwMDVlNDM0MjAwMDAgeDkgOiAwMDAw
MDAwMDAwMDAwMDAwClsgICAgOS4zMTk5NDhdIHg4IDogZmZmZjAwMDAxNjdlODA0YyB4NyA6IDAw
MDAwMDAwMDAwMDAwMDAgeDYgOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgOS4zMTk5NDldIHg1IDog
ZmZmZjgwMDAwODg5MjA2OCB4NCA6IGU5YmU4MDAwMDg4OTIwNjggeDMgOiBmZmZmMDAwM2RhY2I5
MTA1ClsgICAgOS4zMTk5NTBdIHgyIDogMDAwMDAwMDAwMDAwMDAwMCB4MSA6IGZmZmYwMDAwMDFm
MWNhMDAgeDAgOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgOS4zMTk5NTFdIENhbGwgdHJhY2U6Clsg
ICAgOS4zMTk5NTJdICBfX2NmZzgwMjExX2Nvbm5lY3RfcmVzdWx0KzB4MmZjLzB4NWMwIFtjZmc4
MDIxMV0KWyAgICA5LjMxOTk2MF0gIGNmZzgwMjExX3Byb2Nlc3Nfd2Rldl9ldmVudHMrMHgxNDAv
MHgxODAgW2NmZzgwMjExXQpbICAgIDkuMzE5OTY4XSAgY2ZnODAyMTFfcHJvY2Vzc19yZGV2X2V2
ZW50cysweDMwLzB4NTAgW2NmZzgwMjExXQpbICAgIDkuMzE5OTc1XSAgY2ZnODAyMTFfZXZlbnRf
d29yaysweDI4LzB4NDAgW2NmZzgwMjExXQpbICAgIDkuMzE5OTgzXSAgcHJvY2Vzc19vbmVfd29y
aysweDFkNC8weDMzYwpbICAgIDkuMzE5OTg3XSAgd29ya2VyX3RocmVhZCsweDZjLzB4NDMwClsg
ICAgOS4zMTk5ODhdICBrdGhyZWFkKzB4ZTQvMHhmMApbICAgIDkuMzE5OTkwXSAgcmV0X2Zyb21f
Zm9yaysweDEwLzB4MjAKWyAgICA5LjMxOTk5MV0gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAw
MDAwMCBdLS0tClsgICAgOS4zMjA5ODZdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiB3
bHAxczBmMDogbGluayBiZWNvbWVzIHJlYWR5ClsgICAxMC4yNjMwMDRdIHJma2lsbDogaW5wdXQg
aGFuZGxlciBkaXNhYmxlZApbICAgMTQuNjEwODQ2XSBzeXN0ZW1kLWpvdXJuYWxkWzU2MV06IFRp
bWUganVtcGVkIGJhY2t3YXJkcywgcm90YXRpbmcuCg==
--0000000000005f466805e562a0cf--
