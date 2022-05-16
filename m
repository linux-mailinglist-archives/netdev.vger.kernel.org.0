Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD1D527C33
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbiEPDD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbiEPDDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:03:54 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0B51EC48;
        Sun, 15 May 2022 20:03:48 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E741F3200916;
        Sun, 15 May 2022 23:03:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 15 May 2022 23:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1652670223; x=
        1652756623; bh=a8Iw5DRNEUiaxkH9rG0K7BHwId2BfCmqpY9OPCbFiK4=; b=M
        l186vMLcC23CXP9/YAQU8V76YmLCPb1s8dFZdX9ZA1/YiAQPo1z3k5BAK6o5BemB
        hvuw0cmfbCpQqIql8MLP0/t2HxR1Zq+eepIWMAZEs1ZQ4UouvgK2NVZ1rg0QaNXG
        C8X4fhDDax1JASizy7uudqadmdzmeF7RJG1rkm/NvlKgkMIDN9PCstGCZgl32GMG
        X5GDKJYaxcfJkClgvpVysTOaBImZnivQx+10hQb6xm9xqi7mtD55aLu8u4aW+Gra
        mvdcCLbWn2Q0fhNoqcMNqL25qjdDLq9mG4HvpLDxWiYOEhcfsPcr7+wp4uDmi+HE
        ZWOiUZamSyBYnwU1glMgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1652670223; x=1652756623; bh=a8Iw5DRNEUiax
        kH9rG0K7BHwId2BfCmqpY9OPCbFiK4=; b=X4HnhMxm2Fdj0Yd64bYasXLuEkXqe
        9fs9VqRkMHggKTHI36903V+bqo3E4G9esd5bvQUplC/MTbv/gzza4eMPyoAE9Z/T
        lHawlHxGfAzoChJADitOHxTcABF5+dpFXVp3Dy3bHllspU6uImBkeldPh4SIUzD3
        3/QfzcCINtAx7F8nDOvAwq0/Vr4/QwiAbVdFZm6rs+L+Ilmbki1qDkaAkSxCkniN
        Vc00NDGzEDzUhVhIDgca9/0PSI+3QxGBlfBFrIiUtMZAT+65TvTY2j9Yy7SNH5U2
        zZCKZzg4UCTPniCmQc7UOjQIf9ujAWDr5vBcCcIwqRIryvo4kZdbKSZhw==
X-ME-Sender: <xms:D7-BYjypHufM25weacgoxTMuFi2KcgPN4nH7JTWGwO2oVcJJgsPKYA>
    <xme:D7-BYrQSYEeU_TLXIBAfIqKeUQYxji_yL988_Mzlno3XQ9NCoBN9d4g4jSuOwTW1s
    C_6K_aa1X9yqO6Pqw>
X-ME-Received: <xmr:D7-BYtUGBgIKoSx0weijs5ycoq52LMUrjMg65eOGh_C150SewgAhER7T0m2H3HwS7u9Z6HosVrHl5vV3yKg1i6Eukn5zLxUTDTTvhtWrL8P-ypZXtuo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrheeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepkffuhffvvegjfhgtgfffgggfsehtsgertddt
    reejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucggtffrrghtthgvrhhnpedtgfeuffeghedujefftdekgeetffej
    feffgeevleejjeekjeevueetueegheeghfenucffohhmrghinhepghhithhhuhgsrdgtoh
    hmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhu
    shgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:D7-BYtiy840V_6ZzpL1z8nOrMSRBaT-UH4pk2LLMnlBCsAyV1xhtLw>
    <xmx:D7-BYlD61M6CfsuucYlLWEXOTS3eb3ErUFBnLboAOGnXNRmaOb9TSA>
    <xmx:D7-BYmIQOQwAT41y-6nYK1gRiPSkQ7xP9VaMjdIdxUQt13WxwdEgtw>
    <xmx:D7-BYtwNyXnOtKhGBVKg3LHZ6V5u6gfPdLEobuDWKHvuBGDqkHLi_A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 May 2022 23:03:38 -0400 (EDT)
Message-ID: <a76d41c28918dbdf046e5bc73b9ed67a093e02a1.camel@russell.cc>
Subject: Re: [PATCH 3/5] bpf ppc64: Add instructions for atomic_[cmp]xchg
From:   Russell Currey <ruscur@russell.cc>
To:     Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
In-Reply-To: <20220512074546.231616-4-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
         <20220512074546.231616-4-hbathini@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Date:   Mon, 16 May 2022 13:03:35 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.44.1 
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA1LTEyIGF0IDEzOjE1ICswNTMwLCBIYXJpIEJhdGhpbmkgd3JvdGU6Cj4g
VGhpcyBhZGRzIHR3byBhdG9taWMgb3Bjb2RlcyBCUEZfWENIRyBhbmQgQlBGX0NNUFhDSEcgb24g
cHBjNjQsIGJvdGgKPiBvZiB3aGljaCBpbmNsdWRlIHRoZSBCUEZfRkVUQ0ggZmxhZy7CoCBUaGUg
a2VybmVsJ3MgYXRvbWljX2NtcHhjaGcKPiBvcGVyYXRpb24gZnVuZGFtZW50YWxseSBoYXMgMyBv
cGVyYW5kcywgYnV0IHdlIG9ubHkgaGF2ZSB0d28gcmVnaXN0ZXIKPiBmaWVsZHMuIFRoZXJlZm9y
ZSB0aGUgb3BlcmFuZCB3ZSBjb21wYXJlIGFnYWluc3QgKHRoZSBrZXJuZWwncyBBUEkKPiBjYWxs
cyBpdCAnb2xkJykgaXMgaGFyZC1jb2RlZCB0byBiZSBCUEZfUkVHX1IwLiBBbHNvLCBrZXJuZWwn
cwo+IGF0b21pY19jbXB4Y2hnIHJldHVybnMgdGhlIHByZXZpb3VzIHZhbHVlIGF0IGRzdF9yZWcg
KyBvZmYuIEpJVCB0aGUKPiBzYW1lIGZvciBCUEYgdG9vIHdpdGggcmV0dXJuIHZhbHVlIHB1dCBp
biBCUEZfUkVHXzAuCj4gCj4gwqAgQlBGX1JFR19SMCA9IGF0b21pY19jbXB4Y2hnKGRzdF9yZWcg
KyBvZmYsIEJQRl9SRUdfUjAsIHNyY19yZWcpOwo+IAo+IFNpZ25lZC1vZmYtYnk6IEhhcmkgQmF0
aGluaSA8aGJhdGhpbmlAbGludXguaWJtLmNvbT4KPiAtLS0KPiDCoGFyY2gvcG93ZXJwYy9uZXQv
YnBmX2ppdF9jb21wNjQuYyB8IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPiDCoDEg
ZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYg
LS1naXQgYS9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmMKPiBiL2FyY2gvcG93ZXJw
Yy9uZXQvYnBmX2ppdF9jb21wNjQuYwo+IGluZGV4IDUwNGZhNDU5ZjlmMy4uZGY5ZTIwYjIyY2Ni
IDEwMDY0NAo+IC0tLSBhL2FyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdF9jb21wNjQuYwo+ICsrKyBi
L2FyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdF9jb21wNjQuYwo+IEBAIC03ODMsNiArNzgzLDkgQEAg
aW50IGJwZl9qaXRfYnVpbGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIKPiAqaW1hZ2Us
IHN0cnVjdCBjb2RlZ2VuX2NvbnRleHQgKgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICovCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjYXNlIEJQRl9TVFggfCBC
UEZfQVRPTUlDIHwgQlBGX1c6Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjYXNl
IEJQRl9TVFggfCBCUEZfQVRPTUlDIHwgQlBGX0RXOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdTMyIHNhdmVfcmVnID0gdG1wMl9yZWc7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1MzIgcmV0X3JlZyA9IHNy
Y19yZWc7CgpIaSBIYXJpLAoKU29tZSBjb21waWxlcnNbMF1bMV0gZG9uJ3QgbGlrZSB0aGVzZSBs
YXRlIGRlY2xhcmF0aW9ucyBhZnRlciBjYXNlCmxhYmVsczoKCiAgIGFyY2gvcG93ZXJwYy9uZXQv
YnBmX2ppdF9jb21wNjQuYzogSW4gZnVuY3Rpb24g4oCYYnBmX2ppdF9idWlsZF9ib2R54oCZOgog
ICBhcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmM6NzgxOjQ6IGVycm9yOiBhIGxhYmVs
IGNhbiBvbmx5IGJlCiAgIHBhcnQgb2YgYSBzdGF0ZW1lbnQgYW5kIGEgZGVjbGFyYXRpb24gaXMg
bm90IGEgc3RhdGVtZW50CiAgICAgICB1MzIgc2F2ZV9yZWcgPSB0bXAyX3JlZzsKICAgICAgIF5+
fgogICBhcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmM6NzgyOjQ6IGVycm9yOiBleHBl
Y3RlZCBleHByZXNzaW9uCiAgIGJlZm9yZSDigJh1MzLigJkKICAgICAgIHUzMiByZXRfcmVnID0g
c3JjX3JlZzsKICAgICAgIF5+fgogICBhcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmM6
ODE5OjU6IGVycm9yOiDigJhyZXRfcmVn4oCZIHVuZGVjbGFyZWQKICAgKGZpcnN0IHVzZSBpbiB0
aGlzIGZ1bmN0aW9uKTsgZGlkIHlvdSBtZWFuIOKAmGRzdF9yZWfigJk/CiAgICAgICAgcmV0X3Jl
ZyA9IGJwZl90b19wcGMoQlBGX1JFR18wKTsKICAgCkFkZGluZyBhIHNlbWljb2xvbiBmaXhlcyB0
aGUgZmlyc3QgaXNzdWUsIGkuZS4KCiAgIGNhc2UgQlBGX1NUWCB8IEJQRl9BVE9NSUMgfCBCUEZf
RFc6IDsKICAgCmJ1dCB0aGVuIGl0IGp1c3QgY29tcGxhaW5zIGFib3V0IG1peGVkIGRlY2xhcmF0
aW9ucyBhbmQgY29kZSBpbnN0ZWFkLgoKU28geW91IHNob3VsZCBkZWNsYXJlIHNhdmVfcmVnIGFu
ZCByZXRfcmVnIGF0IHRoZSBiZWdpbm5pbmcgb2YgdGhlIGZvcgpsb29wIGxpa2UgdGhlIHJlc3Qg
b2YgdGhlIHZhcmlhYmxlcy4KCi0gUnVzc2VsbAoKWzBdOiBnY2MgNS41LjAKaHR0cHM6Ly9naXRo
dWIuY29tL3J1c2N1ci9saW51eC1jaS9ydW5zLzY0MTg1NDYxOTM/Y2hlY2tfc3VpdGVfZm9jdXM9
dHJ1ZSNzdGVwOjQ6MTIyClsxXTogY2xhbmcgMTIuMApodHRwczovL2dpdGh1Yi5jb20vcnVzY3Vy
L2xpbnV4LWNpL3J1bnMvNjQxODU0NTMzOD9jaGVja19zdWl0ZV9mb2N1cz10cnVlI3N0ZXA6NDox
MTcKCj4gKwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oC8qIEdldCBvZmZzZXQgaW50byBUTVBfUkVHXzEgKi8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBFTUlUKFBQQ19SQVdfTEkodG1wMV9yZWcsIG9mZikp
Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRtcF9p
ZHggPSBjdHgtPmlkeCAqIDQ7Cj4gQEAgLTgxMyw2ICs4MTYsMjQgQEAgaW50IGJwZl9qaXRfYnVp
bGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIKPiAqaW1hZ2UsIHN0cnVjdCBjb2RlZ2Vu
X2NvbnRleHQgKgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGNhc2UgQlBGX1hPUiB8IEJQRl9GRVRDSDoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRU1JVChQUENfUkFXX1hPUih0
bXAyX3JlZywgdG1wMl9yZWcsCj4gc3JjX3JlZykpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNhc2UgQlBGX0NNUFhDSEc6
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBSZXR1cm4gb2xkIHZhbHVlIGluIEJQRl9SRUdfMCBmb3IK
PiBCUEZfQ01QWENIRyAmCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogaW4gc3JjX3JlZyBmb3Igb3RoZXIgY2FzZXMuCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0X3JlZyA9IGJwZl90b19wcGMoQlBGX1JFR18wKTsKPiArCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgLyogQ29tcGFyZSB3aXRoIG9sZCB2YWx1ZSBpbiBCUEZfUjAKPiAqLwo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
IChzaXplID09IEJQRl9EVykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRU1JVChQUENfUkFXX0NN
UEQoYnBmX3RvX3BwYygKPiBCUEZfUkVHXzApLCB0bXAyX3JlZykpOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgRU1JVChQUENfUkFXX0NNUFcoYnBmX3RvX3BwYygKPiBCUEZf
UkVHXzApLCB0bXAyX3JlZykpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIERvbid0IHNldCBpZiBkaWZmZXJlbnQgZnJv
bSBvbGQKPiB2YWx1ZSAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFBQQ19CQ0NfU0hPUlQoQ09ORF9ORSwgKGN0eC0+aWR4
ICsgMykKPiAqIDQpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZhbGx0aHJvdWdoOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2FzZSBCUEZfWENIRzoKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzYXZlX3Jl
ZyA9IHNyY19yZWc7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZGVmYXVsdDoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJfZXJyX3JhdGVsaW1pdGVk
KAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgImVCUEYgZmlsdGVyIGF0b21pYyBvcCBjb2RlCj4g
JTAyeCAoQCVkKSB1bnN1cHBvcnRlZFxuIiwKPiBAQCAtODIyLDE1ICs4NDMsMTQgQEAgaW50IGJw
Zl9qaXRfYnVpbGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIKPiAqaW1hZ2UsIHN0cnVj
dCBjb2RlZ2VuX2NvbnRleHQgKgo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgLyogc3RvcmUgbmV3IHZhbHVlICovCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHNpemUgPT0gQlBGX0RXKQo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoEVNSVQoUFBDX1JBV19TVERDWCh0bXAyX3JlZywKPiB0bXAxX3JlZywgZHN0X3JlZykpOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoEVNSVQoUFBDX1JBV19TVERDWChzYXZlX3JlZywKPiB0bXAxX3JlZywgZHN0X3JlZykp
Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBFTUlUKFBQQ19SQVdfU1RXQ1godG1wMl9yZWcsCj4gdG1wMV9yZWcsIGRzdF9yZWcp
KTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBFTUlUKFBQQ19SQVdfU1RXQ1goc2F2ZV9yZWcsCj4gdG1wMV9yZWcsIGRzdF9y
ZWcpKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAv
KiB3ZSdyZSBkb25lIGlmIHRoaXMgc3VjY2VlZGVkICovCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgUFBDX0JDQ19TSE9SVChDT05EX05FLCB0bXBfaWR4
KTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
LyogRm9yIHRoZSBCUEZfRkVUQ0ggdmFyaWFudCwgZ2V0IG9sZCB2YWx1ZQo+IGludG8gc3JjX3Jl
ZyAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
IChpbW0gJiBCUEZfRkVUQ0gpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRU1JVChQUENfUkFXX01SKHNyY19yZWcsIF9SMCkp
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoEVNSVQoUFBDX1JBV19NUihyZXRfcmVnLCBfUjApKTsKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiDCoAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKCg==

