Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4EEB356B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfIPHRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:17:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53562 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfIPHRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:17:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id i16so2879895wmd.3
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=siENZH/YpLx5ktumLJIDR0BgYCgK+7/Qt8m/L0owmbs=;
        b=ZKxop6YJQPfgk16ww4/9sg+d8dnNXjn82tfSUGXAZARArU4QB+m24eA3O3K5c7OP8j
         hRwuAiwFn3Z60qfZgNpvehOT9i6lVR0j6szjZpZG4jI0AhEymPhL1bOCNkp6nAISFkDu
         mbcD6B118xH5MLhlo7GOZwFcaKe9pHNGgFO4TYyZ/ZcSLFca+01HQPf0pq84H9E6lARF
         1EtrCatjP1vw6hXnoww+9FbuFSZPkGeU10RGtTZF/ma9TPl1qkJAbdSpSZp5rg1Q1oFH
         tf+XFXg/pONkdsFUISuahRu9X4Pe00e49NuSR5Cl9CTzEvVIt/miq2/yUooLpAOyGrtr
         osRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=siENZH/YpLx5ktumLJIDR0BgYCgK+7/Qt8m/L0owmbs=;
        b=tngENbr5FA9PRbuFkMLbcABqQon7oHIAT6Rp+B9Kn3PZFR8LDFmUqET6yJK96LihRu
         1jvY6r3wU+bfAS3f3y3mm4je61f6R2dt6bOE2ljYBvHUAcU//j6WayM5RjrK8LYGkGVJ
         yex/oPncgvkPD5rIdMWwu9QRvt0bMreUPnoz+E5RBOBX51HjpLYXLYnOHsAljv6PKyy2
         G8Hweg4bwqe6ltXLlf3aiiMFpGCi5TZd2IxeccvAEG7polk/QNDk4gLkNpbjNpLhCD1i
         jyLGk2HKgMuK/mwxaC+fbBfCuAID30SHzfYBCfUPifzri8P8F4BJo310scXC5GVQ7Faw
         nAKQ==
X-Gm-Message-State: APjAAAXZfme5UL2UzdYsnuyydMgdDH/slqM0hrb/tAw5WzH1QrGz8Xi7
        Fw1Xx/O0kYWZiMkzd0M3NgiztNs7IfD67MKEKzTPPycC
X-Google-Smtp-Source: APXvYqwvqC1F0fDpjLsVwr1LcaiE5SLMgU7sb1uym02M/DVqxGF0W/syvkTUzj4cOUKnafzsv9zs5YM1tk2tSL3Muew=
X-Received: by 2002:a1c:7319:: with SMTP id d25mr12367217wmb.56.1568618256695;
 Mon, 16 Sep 2019 00:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 16 Sep 2019 15:17:26 +0800
Message-ID: <CADvbK_eHzu-4u3F8jO5G8DtwZAPZv8OX9f-FW+as3mk7BbFnmg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] net: add support for ip_tun_info options setting
To:     network dev <netdev@vger.kernel.org>
Cc:     davem <davem@davemloft.net>, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, William Tu <u9012063@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000faaec40592a6654b"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000faaec40592a6654b
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 16, 2019 at 3:10 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> With this patchset, users can configure options with LWTUNNEL_IP(6)_OPTS
> by ip route encap for ersapn or vxlan lwtunnel. Note that in kernel part
> it won't parse the option details but do some check and memcpy only, and
> the options will be parsed by iproute in userspace.
>
> We also improve the vxlan and erspan options processing in this patchset.
>
> As an example I also wrote a patch for iproute2 that I will reply on this
> mail, with it we can add options for erspan lwtunnel like:
>
>    # ip net a a; ip net a b
>    # ip -n a l a eth0 type veth peer name eth0 netns b
>    # ip -n a l s eth0 up; ip -n b link set eth0 up
>    # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
>    # ip -n b l a erspan1 type erspan key 1 seq erspan 123 \
>         local 10.1.0.2 remote 10.1.0.1
>    # ip -n b a a 1.1.1.1/24 dev erspan1; ip -n b l s erspan1 up
>    # ip -n b r a 2.1.1.0/24 dev erspan1
>    # ip -n a l a erspan1 type erspan key 1 seq local 10.1.0.1 external
>    # ip -n a a a 2.1.1.1/24 dev erspan1; ip -n a l s erspan1 up
>    # ip -n a r a 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
>         dst 10.1.0.2 dev erspan1
>    # ip -n a r s; ip net exec a ping 1.1.1.1 -c 1
the iproute2 patch for testing is as attached.

>
> Xin Long (6):
>   lwtunnel: add options process for arp request
>   lwtunnel: add LWTUNNEL_IP_OPTS support for lwtunnel_ip
>   lwtunnel: add LWTUNNEL_IP6_OPTS support for lwtunnel_ip6
>   vxlan: check tun_info options_len properly
>   erspan: fix the tun_info options_len check
>   erspan: make md work without TUNNEL_ERSPAN_OPT set
>
>  drivers/net/vxlan.c           |  6 +++--
>  include/uapi/linux/lwtunnel.h |  2 ++
>  net/ipv4/ip_gre.c             | 31 ++++++++++-------------
>  net/ipv4/ip_tunnel_core.c     | 59 +++++++++++++++++++++++++++++++++----------
>  net/ipv6/ip6_gre.c            | 35 +++++++++++++------------
>  5 files changed, 84 insertions(+), 49 deletions(-)
>
> --
> 2.1.0
>

--000000000000faaec40592a6654b
Content-Type: application/octet-stream; 
	name="0001-iproute_lwtunnel-add-support-options-for-erspan-meta.patch"
Content-Disposition: attachment; 
	filename="0001-iproute_lwtunnel-add-support-options-for-erspan-meta.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0m2srh50>
X-Attachment-Id: f_k0m2srh50

RnJvbSBjODUyZThiNGM2ODM4YjViZWVkM2U0NzdiYjZiZmI5ZGJkOWIyOTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBYaW4gTG9uZyA8bHVjaWVuLnhpbkBnbWFpbC5jb20+CkRhdGU6
IE1vbiwgMTYgU2VwIDIwMTkgMDM6MTQ6MDcgLTA0MDAKU3ViamVjdDogW1BBVENIXSBpcHJvdXRl
X2x3dHVubmVsOiBhZGQgc3VwcG9ydCBvcHRpb25zIGZvciBlcnNwYW4gbWV0YWRhdGEKClNpZ25l
ZC1vZmYtYnk6IFhpbiBMb25nIDxsdWNpZW4ueGluQGdtYWlsLmNvbT4KLS0tCiBpbmNsdWRlL3Vh
cGkvbGludXgvbHd0dW5uZWwuaCB8ICAgMiArCiBpcC9pcHJvdXRlX2x3dHVubmVsLmMgICAgICAg
ICB8IDEzMSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDEyOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvdWFwaS9saW51eC9sd3R1bm5lbC5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2x3dHVubmVsLmgK
aW5kZXggM2YzZmU2ZjMuLmMyNWZmOTJkIDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
bHd0dW5uZWwuaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvbHd0dW5uZWwuaApAQCAtMjcsNiAr
MjcsNyBAQCBlbnVtIGx3dHVubmVsX2lwX3QgewogCUxXVFVOTkVMX0lQX1RPUywKIAlMV1RVTk5F
TF9JUF9GTEFHUywKIAlMV1RVTk5FTF9JUF9QQUQsCisJTFdUVU5ORUxfSVBfT1BUUywKIAlfX0xX
VFVOTkVMX0lQX01BWCwKIH07CiAKQEAgLTQxLDYgKzQyLDcgQEAgZW51bSBsd3R1bm5lbF9pcDZf
dCB7CiAJTFdUVU5ORUxfSVA2X1RDLAogCUxXVFVOTkVMX0lQNl9GTEFHUywKIAlMV1RVTk5FTF9J
UDZfUEFELAorCUxXVFVOTkVMX0lQNl9PUFRTLAogCV9fTFdUVU5ORUxfSVA2X01BWCwKIH07CiAK
ZGlmZiAtLWdpdCBhL2lwL2lwcm91dGVfbHd0dW5uZWwuYyBiL2lwL2lwcm91dGVfbHd0dW5uZWwu
YwppbmRleCAwMzIxN2I4Zi4uZmY3ZWI0NTAgMTAwNjQ0Ci0tLSBhL2lwL2lwcm91dGVfbHd0dW5u
ZWwuYworKysgYi9pcC9pcHJvdXRlX2x3dHVubmVsLmMKQEAgLTMyLDYgKzMyLDcgQEAKICNpbmNs
dWRlIDxsaW51eC9zZWc2X2htYWMuaD4KICNpbmNsdWRlIDxsaW51eC9zZWc2X2xvY2FsLmg+CiAj
aW5jbHVkZSA8bGludXgvaWZfdHVubmVsLmg+CisjaW5jbHVkZSA8bGludXgvZXJzcGFuLmg+CiAK
IHN0YXRpYyBjb25zdCBjaGFyICpmb3JtYXRfZW5jYXBfdHlwZShpbnQgdHlwZSkKIHsKQEAgLTI5
NCw3ICsyOTUsNyBAQCBzdGF0aWMgdm9pZCBwcmludF9lbmNhcF9tcGxzKEZJTEUgKmZwLCBzdHJ1
Y3QgcnRhdHRyICplbmNhcCkKIHN0YXRpYyB2b2lkIHByaW50X2VuY2FwX2lwKEZJTEUgKmZwLCBz
dHJ1Y3QgcnRhdHRyICplbmNhcCkKIHsKIAlzdHJ1Y3QgcnRhdHRyICp0YltMV1RVTk5FTF9JUF9N
QVgrMV07Ci0JX191MTYgZmxhZ3M7CisJX191MTYgZmxhZ3MgPSAwOwogCiAJcGFyc2VfcnRhdHRy
X25lc3RlZCh0YiwgTFdUVU5ORUxfSVBfTUFYLCBlbmNhcCk7CiAKQEAgLTMyOSw2ICszMzAsMjUg
QEAgc3RhdGljIHZvaWQgcHJpbnRfZW5jYXBfaXAoRklMRSAqZnAsIHN0cnVjdCBydGF0dHIgKmVu
Y2FwKQogCQlpZiAoZmxhZ3MgJiBUVU5ORUxfU0VRKQogCQkJcHJpbnRfYm9vbChQUklOVF9BTlks
ICJzZXEiLCAic2VxICIsIHRydWUpOwogCX0KKworCWlmICh0YltMV1RVTk5FTF9JUF9PUFRTXSkg
eworCQlpZiAoZmxhZ3MgJiBUVU5ORUxfRVJTUEFOX09QVCkgeworCQkJc3RydWN0IGVyc3Bhbl9t
ZXRhZGF0YSAqZW0gPSBSVEFfREFUQSh0YltMV1RVTk5FTF9JUF9PUFRTXSk7CisKKwkJCWlmIChl
bS0+dmVyc2lvbiA9PSAxKSB7CisJCQkJcHJpbnRfYm9vbChQUklOVF9BTlksICJlcnNwYW4iLCAi
ZXJzcGFuICIsIHRydWUpOworCQkJCXByaW50X3VpbnQoUFJJTlRfQU5ZLCAidmVyIiwgInZlciAl
dSAiLCAxKTsKKwkJCQlwcmludF91aW50KFBSSU5UX0FOWSwgImlkeCIsICJpZHggJXUgIiwKKwkJ
CQkJICAgbnRvaGwoZW0tPnUuaW5kZXgpKTsKKwkJCX0gZWxzZSBpZiAoZW0tPnZlcnNpb24gPT0g
MikgeworCQkJCXByaW50X2Jvb2woUFJJTlRfQU5ZLCAiZXJzcGFuIiwgImVyc3BhbiAiLCB0cnVl
KTsKKwkJCQlwcmludF9jb2xvcl9zdHJpbmcoUFJJTlRfQU5ZLCBDT0xPUl9JTkVULAorCQkJCQkJ
ICAgImRpciIsICJkaXIgJXMgIiwKKwkJCQkJCSAgIGVtLT51Lm1kMi5kaXIgPyAiaW5ncmVzcyIg
OiAiZXhncmVzcyIpOworCQkJCXByaW50X3VpbnQoUFJJTlRfQU5ZLCAiaHdpZCIsICJod2lkICV1
ICIsIGVtLT51Lm1kMi5od2lkKTsKKwkJCX0KKwkJfQorCX0KIH0KIAogc3RhdGljIHZvaWQgcHJp
bnRfZW5jYXBfaWxhKEZJTEUgKmZwLCBzdHJ1Y3QgcnRhdHRyICplbmNhcCkKQEAgLTM2NSw3ICsz
ODUsNyBAQCBzdGF0aWMgdm9pZCBwcmludF9lbmNhcF9pbGEoRklMRSAqZnAsIHN0cnVjdCBydGF0
dHIgKmVuY2FwKQogc3RhdGljIHZvaWQgcHJpbnRfZW5jYXBfaXA2KEZJTEUgKmZwLCBzdHJ1Y3Qg
cnRhdHRyICplbmNhcCkKIHsKIAlzdHJ1Y3QgcnRhdHRyICp0YltMV1RVTk5FTF9JUDZfTUFYKzFd
OwotCV9fdTE2IGZsYWdzOworCV9fdTE2IGZsYWdzID0gMDsKIAogCXBhcnNlX3J0YXR0cl9uZXN0
ZWQodGIsIExXVFVOTkVMX0lQNl9NQVgsIGVuY2FwKTsKIApAQCAtNDAxLDYgKzQyMSwyNSBAQCBz
dGF0aWMgdm9pZCBwcmludF9lbmNhcF9pcDYoRklMRSAqZnAsIHN0cnVjdCBydGF0dHIgKmVuY2Fw
KQogCQlpZiAoZmxhZ3MgJiBUVU5ORUxfU0VRKQogCQkJcHJpbnRfYm9vbChQUklOVF9BTlksICJz
ZXEiLCAic2VxICIsIHRydWUpOwogCX0KKworCWlmICh0YltMV1RVTk5FTF9JUDZfT1BUU10pIHsK
KwkJaWYgKGZsYWdzICYgVFVOTkVMX0VSU1BBTl9PUFQpIHsKKwkJCXN0cnVjdCBlcnNwYW5fbWV0
YWRhdGEgKmVtID0gUlRBX0RBVEEodGJbTFdUVU5ORUxfSVA2X09QVFNdKTsKKworCQkJaWYgKGVt
LT52ZXJzaW9uID09IDEpIHsKKwkJCQlwcmludF9ib29sKFBSSU5UX0FOWSwgImVyc3BhbiIsICJl
cnNwYW4gIiwgdHJ1ZSk7CisJCQkJcHJpbnRfdWludChQUklOVF9BTlksICJ2ZXIiLCAidmVyICV1
ICIsIDEpOworCQkJCXByaW50X3VpbnQoUFJJTlRfQU5ZLCAiaWR4IiwgImlkeCAldSAiLAorCQkJ
CQkgICBudG9obChlbS0+dS5pbmRleCkpOworCQkJfSBlbHNlIGlmIChlbS0+dmVyc2lvbiA9PSAy
KSB7CisJCQkJcHJpbnRfYm9vbChQUklOVF9BTlksICJlcnNwYW4iLCAiZXJzcGFuICIsIHRydWUp
OworCQkJCXByaW50X2NvbG9yX3N0cmluZyhQUklOVF9BTlksIENPTE9SX0lORVQsCisJCQkJCQkg
ICAiZGlyIiwgImRpciAlcyAiLAorCQkJCQkJICAgZW0tPnUubWQyLmRpciA/ICJpbmdyZXNzIiA6
ICJleGdyZXNzIik7CisJCQkJcHJpbnRfdWludChQUklOVF9BTlksICJod2lkIiwgImh3aWQgJXUg
IiwgZW0tPnUubWQyLmh3aWQpOworCQkJfQorCQl9CisJfQogfQogCiBzdGF0aWMgdm9pZCBwcmlu
dF9lbmNhcF9icGYoRklMRSAqZnAsIHN0cnVjdCBydGF0dHIgKmVuY2FwKQpAQCAtNzk5LDcgKzgz
OCw3IEBAIHN0YXRpYyBpbnQgcGFyc2VfZW5jYXBfaXAoc3RydWN0IHJ0YXR0ciAqcnRhLCBzaXpl
X3QgbGVuLAogCQkJICBpbnQgKmFyZ2NwLCBjaGFyICoqKmFyZ3ZwKQogewogCWludCBpZF9vayA9
IDAsIGRzdF9vayA9IDAsIHNyY19vayA9IDAsIHRvc19vayA9IDAsIHR0bF9vayA9IDA7Ci0JaW50
IGtleV9vayA9IDAsIGNzdW1fb2sgPSAwLCBzZXFfb2sgPSAwOworCWludCBrZXlfb2sgPSAwLCBj
c3VtX29rID0gMCwgc2VxX29rID0gMCwgZXJzcGFuX29rID0gMDsKIAljaGFyICoqYXJndiA9ICph
cmd2cDsKIAlpbnQgYXJnYyA9ICphcmdjcDsKIAlpbnQgcmV0ID0gMDsKQEAgLTg1MSw2ICs4OTAs
NDggQEAgc3RhdGljIGludCBwYXJzZV9lbmNhcF9pcChzdHJ1Y3QgcnRhdHRyICpydGEsIHNpemVf
dCBsZW4sCiAJCQlpZiAoZ2V0X3U4KCZ0dGwsICphcmd2LCAwKSkKIAkJCQlpbnZhcmcoIlwidHRs
XCIgdmFsdWUgaXMgaW52YWxpZFxuIiwgKmFyZ3YpOwogCQkJcmV0ID0gcnRhX2FkZGF0dHI4KHJ0
YSwgbGVuLCBMV1RVTk5FTF9JUF9UVEwsIHR0bCk7CisJCX0gZWxzZSBpZiAoc3RyY21wKCphcmd2
LCAiZXJzcGFuIikgPT0gMCkgeworCQkJc3RydWN0IGVyc3Bhbl9tZXRhZGF0YSBlbTsKKworCQkJ
bWVtc2V0KCZlbSwgMCwgc2l6ZW9mKGVtKSk7CisJCQlpZiAoZXJzcGFuX29rKyspCisJCQkJZHVw
YXJnMigiZXJzcGFuIiwgKmFyZ3YpOworCQkJZmxhZ3MgfD0gVFVOTkVMX0VSU1BBTl9PUFQ7CisJ
CQlORVhUX0FSRygpOworCQkJaWYgKHN0cmNtcCgqYXJndiwgInZlciIpKQorCQkJCWR1cGFyZzIo
InZlciIsICphcmd2KTsKKwkJCU5FWFRfQVJHKCk7CisJCQlpZiAoZ2V0X3MzMigmZW0udmVyc2lv
biwgKmFyZ3YsIDApIHx8CisJCQkgICAgKGVtLnZlcnNpb24gIT0gMSAmJiBlbS52ZXJzaW9uICE9
IDIpKQorCQkJCWludmFyZygiXCJ0b3NcIiB2YWx1ZSBpcyBpbnZhbGlkXG4iLCAqYXJndik7CisJ
CQlORVhUX0FSRygpOworCQkJaWYgKGVtLnZlcnNpb24gPT0gMSkgeworCQkJCWlmIChzdHJjbXAo
KmFyZ3YsICJpZHgiKSkKKwkJCQkJZHVwYXJnMigiaWR4IiwgKmFyZ3YpOworCQkJCU5FWFRfQVJH
KCk7CisJCQkJaWYgKGdldF9iZTMyKCZlbS51LmluZGV4LCAqYXJndiwgMCkpCisJCQkJCWludmFy
ZygiXCJpZHhcIiB2YWx1ZSBpcyBpbnZhbGlkXG4iLCAqYXJndik7CisJCQl9IGVsc2UgeworCQkJ
CV9fdTggaHdpZDsKKworCQkJCWlmIChzdHJjbXAoKmFyZ3YsICJkaXIiKSkKKwkJCQkJZHVwYXJn
MigiZGlyIiwgKmFyZ3YpOworCQkJCU5FWFRfQVJHKCk7CisJCQkJaWYgKHN0cmNtcCgqYXJndiwg
ImluZ3Jlc3MiKSA9PSAwKQorCQkJCQllbS51Lm1kMi5kaXIgPSAwOworCQkJCWVsc2UgaWYgKHN0
cmNtcCgqYXJndiwgImV4Z3Jlc3MiKSA9PSAwKQorCQkJCQllbS51Lm1kMi5kaXIgPSAxOworCQkJ
CWVsc2UKKwkJCQkJaW52YXJnKCJcImRpclwiIHZhbHVlIGlzIGludmFsaWRcbiIsICphcmd2KTsK
KwkJCQlORVhUX0FSRygpOworCQkJCWlmIChzdHJjbXAoKmFyZ3YsICJod2lkIikpCisJCQkJCWR1
cGFyZzIoImh3aWQiLCAqYXJndik7CisJCQkJTkVYVF9BUkcoKTsKKwkJCQlpZiAoZ2V0X3U4KCZo
d2lkLCAqYXJndiwgMCkpCisJCQkJCWludmFyZygiXCJod2lkXCIgdmFsdWUgaXMgaW52YWxpZFxu
IiwgKmFyZ3YpOworCQkJCWVtLnUubWQyLmh3aWQgPSBod2lkOworCQkJfQorCQkJcnRhX2FkZGF0
dHJfbChydGEsIGxlbiwgTFdUVU5ORUxfSVBfT1BUUywgJmVtLCBzaXplb2YoZW0pKTsKIAkJfSBl
bHNlIGlmIChzdHJjbXAoKmFyZ3YsICJrZXkiKSA9PSAwKSB7CiAJCQlpZiAoa2V5X29rKyspCiAJ
CQkJZHVwYXJnMigia2V5IiwgKmFyZ3YpOwpAQCAtOTY2LDcgKzEwNDcsNyBAQCBzdGF0aWMgaW50
IHBhcnNlX2VuY2FwX2lwNihzdHJ1Y3QgcnRhdHRyICpydGEsIHNpemVfdCBsZW4sCiAJCQkgICBp
bnQgKmFyZ2NwLCBjaGFyICoqKmFyZ3ZwKQogewogCWludCBpZF9vayA9IDAsIGRzdF9vayA9IDAs
IHNyY19vayA9IDAsIHRvc19vayA9IDAsIHR0bF9vayA9IDA7Ci0JaW50IGtleV9vayA9IDAsIGNz
dW1fb2sgPSAwLCBzZXFfb2sgPSAwOworCWludCBrZXlfb2sgPSAwLCBjc3VtX29rID0gMCwgc2Vx
X29rID0gMCwgZXJzcGFuX29rID0gMDsKIAljaGFyICoqYXJndiA9ICphcmd2cDsKIAlpbnQgYXJn
YyA9ICphcmdjcDsKIAlpbnQgcmV0ID0gMDsKQEAgLTEwMjAsNiArMTEwMSw0OCBAQCBzdGF0aWMg
aW50IHBhcnNlX2VuY2FwX2lwNihzdHJ1Y3QgcnRhdHRyICpydGEsIHNpemVfdCBsZW4sCiAJCQkJ
ICAgICAgICphcmd2KTsKIAkJCXJldCA9IHJ0YV9hZGRhdHRyOChydGEsIGxlbiwgTFdUVU5ORUxf
SVA2X0hPUExJTUlULAogCQkJCQkgICBob3BsaW1pdCk7CisJCX0gZWxzZSBpZiAoc3RyY21wKCph
cmd2LCAiZXJzcGFuIikgPT0gMCkgeworCQkJc3RydWN0IGVyc3Bhbl9tZXRhZGF0YSBlbTsKKwor
CQkJbWVtc2V0KCZlbSwgMCwgc2l6ZW9mKGVtKSk7CisJCQlpZiAoZXJzcGFuX29rKyspCisJCQkJ
ZHVwYXJnMigiZXJzcGFuIiwgKmFyZ3YpOworCQkJZmxhZ3MgfD0gVFVOTkVMX0VSU1BBTl9PUFQ7
CisJCQlORVhUX0FSRygpOworCQkJaWYgKHN0cmNtcCgqYXJndiwgInZlciIpKQorCQkJCWR1cGFy
ZzIoInZlciIsICphcmd2KTsKKwkJCU5FWFRfQVJHKCk7CisJCQlpZiAoZ2V0X3MzMigmZW0udmVy
c2lvbiwgKmFyZ3YsIDApIHx8CisJCQkgICAgKGVtLnZlcnNpb24gIT0gMSAmJiBlbS52ZXJzaW9u
ICE9IDIpKQorCQkJCWludmFyZygiXCJ0b3NcIiB2YWx1ZSBpcyBpbnZhbGlkXG4iLCAqYXJndik7
CisJCQlORVhUX0FSRygpOworCQkJaWYgKGVtLnZlcnNpb24gPT0gMSkgeworCQkJCWlmIChzdHJj
bXAoKmFyZ3YsICJpZHgiKSkKKwkJCQkJZHVwYXJnMigiaWR4IiwgKmFyZ3YpOworCQkJCU5FWFRf
QVJHKCk7CisJCQkJaWYgKGdldF9iZTMyKCZlbS51LmluZGV4LCAqYXJndiwgMCkpCisJCQkJCWlu
dmFyZygiXCJpZHhcIiB2YWx1ZSBpcyBpbnZhbGlkXG4iLCAqYXJndik7CisJCQl9IGVsc2Ugewor
CQkJCV9fdTggaHdpZDsKKworCQkJCWlmIChzdHJjbXAoKmFyZ3YsICJkaXIiKSkKKwkJCQkJZHVw
YXJnMigiZGlyIiwgKmFyZ3YpOworCQkJCU5FWFRfQVJHKCk7CisJCQkJaWYgKHN0cmNtcCgqYXJn
diwgImluZ3Jlc3MiKSA9PSAwKQorCQkJCQllbS51Lm1kMi5kaXIgPSAwOworCQkJCWVsc2UgaWYg
KHN0cmNtcCgqYXJndiwgImV4Z3Jlc3MiKSA9PSAwKQorCQkJCQllbS51Lm1kMi5kaXIgPSAxOwor
CQkJCWVsc2UKKwkJCQkJaW52YXJnKCJcImRpclwiIHZhbHVlIGlzIGludmFsaWRcbiIsICphcmd2
KTsKKwkJCQlORVhUX0FSRygpOworCQkJCWlmIChzdHJjbXAoKmFyZ3YsICJod2lkIikpCisJCQkJ
CWR1cGFyZzIoImh3aWQiLCAqYXJndik7CisJCQkJTkVYVF9BUkcoKTsKKwkJCQlpZiAoZ2V0X3U4
KCZod2lkLCAqYXJndiwgMCkpCisJCQkJCWludmFyZygiXCJod2lkXCIgdmFsdWUgaXMgaW52YWxp
ZFxuIiwgKmFyZ3YpOworCQkJCWVtLnUubWQyLmh3aWQgPSBod2lkOworCQkJfQorCQkJcnRhX2Fk
ZGF0dHJfbChydGEsIGxlbiwgTFdUVU5ORUxfSVA2X09QVFMsICZlbSwgc2l6ZW9mKGVtKSk7CiAJ
CX0gZWxzZSBpZiAoc3RyY21wKCphcmd2LCAia2V5IikgPT0gMCkgewogCQkJaWYgKGtleV9vaysr
KQogCQkJCWR1cGFyZzIoImtleSIsICphcmd2KTsKLS0gCjIuMTguMQoK
--000000000000faaec40592a6654b--
