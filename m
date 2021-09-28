Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918FA41AAAB
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbhI1Ihc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbhI1Iha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 04:37:30 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718F2C061575;
        Tue, 28 Sep 2021 01:35:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id b82so29223157ybg.1;
        Tue, 28 Sep 2021 01:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VkqOXfHINA+UZ7ncjJqcgVt9KM5mqN2AU4qxmIR04Ww=;
        b=KwmceUcpNHtIhwmgml8dRJAWZBkf3N1tz0837q7wOglPnhgZbiBiaHveMoI+GKCkaO
         9fSRAuTZqHX/B2+Wz8yq6JlVanohWSYcMGNt+k1n05jAdqgZVPrRT+q6KDUuxVf5+FYe
         nUan9ZSqN603cNiZhtD/zIZRjqAVEHmZGGg2OKd3/Wr11Bm24G8bPnxYR2w/WoqDSdrA
         L8k7ZZ/aGoP0gaWuL8/ZtoS+022b4ofGF0gNoW65h9ztD2mU15MFNH+IDWPYzSjf49Wy
         0XYrqkD/YsDSyoLqg29hVIv8S7m5BhPfbCjggfCMtKtfj88B9uj8VSK5/SbIukv3josw
         97Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VkqOXfHINA+UZ7ncjJqcgVt9KM5mqN2AU4qxmIR04Ww=;
        b=3m6aAKhJmWbVv5DYz499ERg8rGFSc7A5n2PTWbAIpBAGvqWUjDRQm1a6qK2bJcsqoJ
         0hIFEcsX2sSKJsBySKhuR9bEJdFNK+mYTFWtkOg3NNPXaonSW2uoLYHyvBHfadnZ9CkA
         2bdWHNKAQdf+QW9hqdFfLz5o35il9i9CAexELXssavMgO4JEfRmamDlsjjEYckDDKuoH
         1un0zBdi24QQVaDM6BQtVrGe9rTxrtzlJJKqxzLXW9L9soIlzBG6I40LX6igMGMIvPrM
         kn7Ck1TxlzUew3Q3XeHWpiNrE5Qgh2U5M82QyZSVUAsR0EFImTTWmVEjj0Ymp1UCq3xT
         LLxg==
X-Gm-Message-State: AOAM533dXooNO5bSQwzC1LuYWQjKMzN7oFvpFEhGt3JrJupOJElCwfh9
        jRzZlyEf75WvZtMWgEl+sxVNhEhqZhng+CBA638=
X-Google-Smtp-Source: ABdhPJx+N772rkFl8TgYYnPHITbDZML6nU9VQF7XwiTvq7xfQ2qVjaojJfNShYL3RWazPhIqaTSyhA+wWnbzc+FrEBQ=
X-Received: by 2002:a25:cc8:: with SMTP id 191mr5207905ybm.63.1632818150581;
 Tue, 28 Sep 2021 01:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOvGQrRTaTkaJ0p3zR7y7nrAWD79r48=L_BbOyrK9X-vA@mail.gmail.com>
 <CAK8P3a0kG_gdpaOoLb5H2qeq-T7orQ+2n19NNWQaRKgVNotDkw@mail.gmail.com> <CAFcO6XOgtizsTQbeWcD14yiMAaRp82QomNhSehCJ4t=d2CRx+g@mail.gmail.com>
In-Reply-To: <CAFcO6XOgtizsTQbeWcD14yiMAaRp82QomNhSehCJ4t=d2CRx+g@mail.gmail.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Tue, 28 Sep 2021 16:35:39 +0800
Message-ID: <CAFcO6XN+N-O3hSd+HK+Zn76B1tKpeFueTkbdV0vycwGpJq4PtA@mail.gmail.com>
Subject: Re: There is an array-index-out-bounds bug in detach_capi_ctr in drivers/isdn/capi/kcapi.c
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000dac7b105cd0a1934"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dac7b105cd0a1934
Content-Type: text/plain; charset="UTF-8"

Hi, I make a patch for this issue.

Regards,
 butt3rflyh4ck.


On Fri, Sep 24, 2021 at 6:02 PM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> > When I last touched the capi code, I tried to remove it all, but we then
> > left it in the kernel because the bluetooth cmtp code can still theoretically
> > use it.
> >
> > May I ask how you managed to run into this? Did you find the bug through
> > inspection first and then produce it using cmtp, or did you actually use
> > cmtp?
>
> I fuzz the bluez system and find a crash to analyze it and reproduce it.
>
> > If the only purpose of cmtp is now to be a target for exploits, then I
> > would suggest we consider removing both cmtp and capi for
> > good after backporting your fix to stable kernels. Obviously
> > if it turns out that someone actually uses cmtp and/or capi, we
> > should not remove it.
> >
> Yes, I think this should be feasible.
>
> Regards
>   butt3rflyh4ck.
>
>
> --
> Active Defense Lab of Venustech



-- 
Active Defense Lab of Venustech

--000000000000dac7b105cd0a1934
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-isdn-cpai-check-ctr-cnr-to-avoid-array-index-out-of-.patch"
Content-Disposition: attachment; 
	filename="0001-isdn-cpai-check-ctr-cnr-to-avoid-array-index-out-of-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ku3tr7kr0>
X-Attachment-Id: f_ku3tr7kr0

RnJvbSAxNTQ0OWJiNWFhYzFmODI4ZGM4MjA1NDY1MWZlOGY0ZGNhMzdiZWY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBYaWFvbG9uZyBIdWFuZyA8YnV0dGVyZmx5aHVhbmd4eEBnbWFp
bC5jb20+CkRhdGU6IFR1ZSwgMjggU2VwIDIwMjEgMTM6MDM6NDEgKzA4MDAKU3ViamVjdDogW1BB
VENIXSBpc2RuOiBjcGFpOiBjaGVjayBjdHItPmNuciB0byBhdm9pZCBhcnJheSBpbmRleCBvdXQg
b2YgYm91bmQKClRoZSBjbXRwX2FkZF9jb25uZWN0aW9uKCkgd291bGQgYWRkIGEgY210cCBzZXNz
aW9uIHRvIGEgY29udHJvbGxlciBhbmQgcnVuIGEga2VybmVsCnRocmVhZCB0byBwcm9jZXNzIGNt
dHAuCgoJX19tb2R1bGVfZ2V0KFRISVNfTU9EVUxFKTsKCXNlc3Npb24tPnRhc2sgPSBrdGhyZWFk
X3J1bihjbXRwX3Nlc3Npb24sIHNlc3Npb24sICJrY210cGRfY3RyXyVkIiwKCQkJCQkJCQlzZXNz
aW9uLT5udW0pOwoKRHVyaW5nIHRoaXMgcHJvY2VzcywgdGhlIGtlcm5lbCB0aHJlYWQgd291bGQg
Y2FsbCBkZXRhY2hfY2FwaV9jdHIoKQp0byBkZXRhY2ggYSByZWdpc3RlciBjb250cm9sbGVyLiBp
ZiB0aGUgY29udHJvbGxlciB3YXMgbm90IGF0dGFjaGVkIHlldCwgZGV0YWNoX2NhcGlfY3RyKCkK
d291bGQgdHJpZ2dlciBhbiBhcnJheS1pbmRleC1vdXQtYm91bmRzIGJ1Zy4KClsgICA0Ni44NjYw
NjldWyBUNjQ3OV0gVUJTQU46IGFycmF5LWluZGV4LW91dC1vZi1ib3VuZHMgaW4KZHJpdmVycy9p
c2RuL2NhcGkva2NhcGkuYzo0ODM6MjEKWyAgIDQ2Ljg2NzE5Nl1bIFQ2NDc5XSBpbmRleCAtMSBp
cyBvdXQgb2YgcmFuZ2UgZm9yIHR5cGUgJ2NhcGlfY3RyICpbMzJdJwpbICAgNDYuODY3OTgyXVsg
VDY0NzldIENQVTogMSBQSUQ6IDY0NzkgQ29tbToga2NtdHBkX2N0cl8wIE5vdCB0YWludGVkCjUu
MTUuMC1yYzIrICM4ClsgICA0Ni44NjkwMDJdWyBUNjQ3OV0gSGFyZHdhcmUgbmFtZTogUUVNVSBT
dGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwKMTk5NiksIEJJT1MgMS4xNC4wLTIgMDQvMDEvMjAx
NApbICAgNDYuODcwMTA3XVsgVDY0NzldIENhbGwgVHJhY2U6ClsgICA0Ni44NzA0NzNdWyBUNjQ3
OV0gIGR1bXBfc3RhY2tfbHZsKzB4NTcvMHg3ZApbICAgNDYuODcwOTc0XVsgVDY0NzldICB1YnNh
bl9lcGlsb2d1ZSsweDUvMHg0MApbICAgNDYuODcxNDU4XVsgVDY0NzldICBfX3Vic2FuX2hhbmRs
ZV9vdXRfb2ZfYm91bmRzLmNvbGQrMHg0My8weDQ4ClsgICA0Ni44NzIxMzVdWyBUNjQ3OV0gIGRl
dGFjaF9jYXBpX2N0cisweDY0LzB4YzAKWyAgIDQ2Ljg3MjYzOV1bIFQ2NDc5XSAgY210cF9zZXNz
aW9uKzB4NWM4LzB4NWQwClsgICA0Ni44NzMxMzFdWyBUNjQ3OV0gID8gX19pbml0X3dhaXRxdWV1
ZV9oZWFkKzB4NjAvMHg2MApbICAgNDYuODczNzEyXVsgVDY0NzldICA/IGNtdHBfYWRkX21zZ3Bh
cnQrMHgxMjAvMHgxMjAKWyAgIDQ2Ljg3NDI1Nl1bIFQ2NDc5XSAga3RocmVhZCsweDE0Ny8weDE3
MApbICAgNDYuODc0NzA5XVsgVDY0NzldICA/IHNldF9rdGhyZWFkX3N0cnVjdCsweDQwLzB4NDAK
WyAgIDQ2Ljg3NTI0OF1bIFQ2NDc5XSAgcmV0X2Zyb21fZm9yaysweDFmLzB4MzAKWyAgIDQ2Ljg3
NTc3M11bIFQ2NDc5XQoKU2lnbmVkLW9mZi1ieTogWGlhb2xvbmcgSHVhbmcgPGJ1dHRlcmZseWh1
YW5neHhAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvaXNkbi9jYXBpL2tjYXBpLmMgfCA1ICsrKysr
CiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9p
c2RuL2NhcGkva2NhcGkuYyBiL2RyaXZlcnMvaXNkbi9jYXBpL2tjYXBpLmMKaW5kZXggY2IwYWZl
ODk3MTYyLi43MzEzNDU0ZTQwM2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaXNkbi9jYXBpL2tjYXBp
LmMKKysrIGIvZHJpdmVycy9pc2RuL2NhcGkva2NhcGkuYwpAQCAtNDgwLDYgKzQ4MCwxMSBAQCBp
bnQgZGV0YWNoX2NhcGlfY3RyKHN0cnVjdCBjYXBpX2N0ciAqY3RyKQogCiAJY3RyX2Rvd24oY3Ry
LCBDQVBJX0NUUl9ERVRBQ0hFRCk7CiAKKwlpZiAoY3RyLT5jbnIgPCAxIHx8IGN0ci0+Y25yIC0g
MSA+PSBDQVBJX01BWENPTlRSKSB7CisJCWVyciA9IC1FSU5WQUw7CisJCWdvdG8gdW5sb2NrX291
dDsKKwl9CisKIAlpZiAoY2FwaV9jb250cm9sbGVyW2N0ci0+Y25yIC0gMV0gIT0gY3RyKSB7CiAJ
CWVyciA9IC1FSU5WQUw7CiAJCWdvdG8gdW5sb2NrX291dDsKLS0gCjIuMjUuMQoK
--000000000000dac7b105cd0a1934--
