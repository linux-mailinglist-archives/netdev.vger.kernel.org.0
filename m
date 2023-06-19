Return-Path: <netdev+bounces-11908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF624735174
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54C01C20985
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32B5C2F1;
	Mon, 19 Jun 2023 10:05:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BB2C14A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:05:35 +0000 (UTC)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C54134
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:05:33 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-7623fdb3637so173256785a.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687169133; x=1689761133;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oJxz74Bxw2ikgl6WA98b2GrKLWLY7dZucscGl0TEpfo=;
        b=isNIWMZAqef6RkmVDs/pBbPbuoPXhFzO4yq1mpLCDE7itFpzLl8QDBbyD+NI1ma0vi
         bU8Jju+5QL//7y2Gf4uTIXTD4Es5uNtnOX/Bel4MPrhF1vXk2pnauMH7nygVgTiSzozA
         6ed/p37Mn42T6OvakWNfAjkH0SdFnNeqC/ZIivUf+4MjwbH/VM7oG5+jgW80HMvMmv2i
         JAKR/uWL42AFthQ257Jv6XoK1OgxdXDt1CNiBF/LHdhuKns7h1/CR0v3GG9uZ5y0tJob
         XwJnvHen7Xhkc4fdpyZKDWG7vyT1kSjKQZB+xjw2ubHshTOOrg1JZueis3+SRnYsyId/
         /2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687169133; x=1689761133;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJxz74Bxw2ikgl6WA98b2GrKLWLY7dZucscGl0TEpfo=;
        b=KpUqeQRUllkI8sFWeLwvr1vATGC7PO6EiAZwfU1cQyhp2z9K6JlxAL7Sk7s5fYK8lN
         5J5kcr250QJJl1C2Ik3UfF4nBHCHnvakEo92MNFcd3taEIGhkg7RDKpU7IIOwVrgz7Pv
         Sv6ApGFJOTIiZ+LaWnGUskGxoWI3UK0O7ViHDnISbk30Fw6qg4STuVCvN7AyooFSPmbh
         bGfIW3Ql+mBIlsm+TA07JjN5O3KGVYSTQuzZdVwhezlxoEracL9p+O2MVkD9+XE1ddQ+
         E6jsCw7QS0avW9QL+o8MQsq8SJw9QMV1r0325eNcOegT3x2TbW20HB6qGHgvMxkWwVCp
         rGbA==
X-Gm-Message-State: AC+VfDxwjyUCY4vg/o33Gv5LMX6roeGIub9fSB4pXvbKuXfbizk6QzrX
	DzR2Uozu5hvqKm5le1OZp3o=
X-Google-Smtp-Source: ACHHUZ5WD5GRwaJc2xA+d4MouuXBUImBM17FgI5+Nhgujy8tfMmQyCY3FKCeBjHNTfDF8x7gutN6Cw==
X-Received: by 2002:a05:620a:8709:b0:763:9fde:adea with SMTP id px9-20020a05620a870900b007639fdeadeamr1058804qkn.15.1687169132748;
        Mon, 19 Jun 2023 03:05:32 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a13ca00b007606a26988dsm7847286qkl.73.2023.06.19.03.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 03:05:32 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,
  donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
In-Reply-To: <20230616111129.311dfd2d@kernel.org> (Jakub Kicinski's message of
	"Fri, 16 Jun 2023 11:11:29 -0700")
Date: Mon, 19 Jun 2023 11:04:11 +0100
Message-ID: <m2v8fjahus.fsf@gmail.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
	<20230615200036.393179ae@kernel.org> <m2o7lfhft6.fsf@gmail.com>
	<20230616111129.311dfd2d@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 16 Jun 2023 11:17:25 +0100 Donald Hunter wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>> > On Thu, 15 Jun 2023 16:13:36 +0100 Donald Hunter wrote:  
>> >
>> > The interpretation depends on another attribute or we expose things 
>> > as binary with no machine-readable indication if its IP addr or MAC etc?  
>> 
>> Yeah, it's the lack of machine-readable indication. I'd suggest adding
>> something like 'format: ipv4-address' to the schema.
>
> I'd prefer to avoid defining our own names, too much thinking :)
> Two ideas which come to mind are to either add a struct reference
> (struct in_addr, in this case) or use the printk formats
> Documentation/core-api/printk-formats.rst (%pI4).

I tried these suggestions out and they seem a bit problematic. For
struct references I don't see a way to validate them, when it's not C
codegen. Non C consumers will need to enumarete the struct references
they 'understand'. The printk formats are meaningful in kernel, but not
directly usable elsewhere, without writing a parser for them.

It seems desirable to have schema validation for the values and I tried
using the %p printk formats as the enumeration. Using this format, the
values need to be quoted everywhere. See diff below.

The printk formats also carry specific opinions about formatting details
such as the case and separator to be used for output. This seems
orthogonal to a type annotation about meaning.

Perhaps the middle ground is to derive a list of format specificer
enumerations from the printk formats, but that's maybe not much
different from defining our own?

I currently have "%pI4", "%pI6", "%pM", "%pMF", "%pU", "%ph", which
could be represented as ipv4, ipv6, mac, fddi, uuid, hex. From the
printk formats documentation, the only other one I can see is bluetooth.
The other formats all look like they cover composite values.

>> >> This seems like a useful tool to have as part of the ynl suite since
>> >> it lowers the cost of getting good strace support for new netlink
>> >> families. But I realise that the generated format is dependent on an
>> >> out of tree project. If there is interest in having this in-tree then
>> >> I can clean it up and address some of the limitations before
>> >> submission.  
>> >
>> > I think it's fine, we'll have to cross this bridge sooner or later.
>> > I suspect we'll need to split ynl-gen-c once again (like the
>> > tools/net/ynl/lib/nlspec.py, maybe we need another layer for code 
>> > generators? nlcodegen or some such?) before we add codegen for more
>> > languages. I'm not sure you actually need that yet, maybe the strace
>> > generator needs just nlspec.py and it can be a separate script?  
>> 
>> The strace generator uses CodeWriter and makes partial use of the Type*
>> classes as well. If we split those out of ynl-gen-c then it could be a
>> separate script. A first step could be to move all but main() into a
>> lib?
>
> Hm, my instinct was the opposite, move as little as possible while
> avoiding duplication. I was thinking about the split in context of
> C++ and Rust, there's a lot of C intermixed with the code currently
> in ynl-gen-c. But you need the C, AFAIU.
>
> You shouldn't need all the print_ stuff, tho, do you? So we could split
> more or less around where _C_KW is defined? Anything above it would be
> shared among C codegens?

Yeah, that makes sense - all the top-level defs after _C_KW are specific
to main() so shouldn't be moved to a lib.

I will do an initial refactor and see how it works out.

Thanks.

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index b474889b49ff..f3ecdeb7c38c 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -119,7 +119,11 @@ properties:
               name:
                 type: string
               type:
                 enum: [ u8, u16, u32, u64, s8, s16, s32, s64, string ]
+              format-specifier: &format-specifier
+                description: Optional format specifier for an attribute
+                enum: [ "%pI4", "%pI6", "%pM", "%pMF", "%pU", "%ph" ]
               len:
                 $ref: '#/$defs/len-or-define'
               byte-order:
@@ -179,8 +183,10 @@ properties:
               name:
                 type: string
               type: &attr-type
+                description: The netlink attribute type
                 enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
                         string, nest, array-nest, nest-type-value ]
+              format-specifier: *format-specifier
               doc:
                 description: Documentation of the attribute.
                 type: string
diff --git a/Documentation/netlink/specs/ovs_flow.yaml b/Documentation/netlink/specs/ovs_flow.yaml
index 1ecbcd117385..08b2918baa27 100644
--- a/Documentation/netlink/specs/ovs_flow.yaml
+++ b/Documentation/netlink/specs/ovs_flow.yaml
@@ -33,6 +33,20 @@ definitions:
         name: n-bytes
         type: u64
         doc: Number of matched bytes.
+  -
+    name: ovs-key-ethernet
+    type: struct
+    members:
+      -
+        name: eth-src
+        type: binary
+        len: 6
+        format-specifier: "%pM"
+      -
+        name: eth-dst
+        type: binary
+        len: 6
+        format-specifier: "%pM"
   -
     name: ovs-key-mpls
     type: struct
@@ -49,10 +63,12 @@ definitions:
         name: ipv4-src
         type: u32
         byte-order: big-endian
+        format-specifier: "%pI4"
       -
         name: ipv4-dst
         type: u32
         byte-order: big-endian
+        format-specifier: "%pI4"
       -
         name: ipv4-proto
         type: u8

