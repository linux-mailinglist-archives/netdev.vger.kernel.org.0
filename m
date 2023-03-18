Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3F76BFBA4
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 17:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjCRQrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCRQrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 12:47:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17D0231D2
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679158023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Flyrkjc9E6KC4yFnPqIBV3fXZOOKc/87PGeRGHBivks=;
        b=dhwcxHNezGD93sM8sRY/w/CnG6rfto8IUaBbGVcq0Qh1sHgvZCUAC9LjQsEVzy1tGhaIiR
        Ue/rT4WSD/Xlm0EcWEFLX2P6NPG/UyY5alBsJzx2Y0/Mx2l0k0atDi63SQLJsxB4oktRTI
        EmiFGd8T8oUsLNGLo277bX+12VQBzxo=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-2kvH3xFpPgajP4tLiFervg-1; Sat, 18 Mar 2023 12:47:01 -0400
X-MC-Unique: 2kvH3xFpPgajP4tLiFervg-1
Received: by mail-yb1-f199.google.com with SMTP id ch1-20020a0569020b0100b00b3cc5b4fa9dso8475753ybb.12
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679158021;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Flyrkjc9E6KC4yFnPqIBV3fXZOOKc/87PGeRGHBivks=;
        b=pBlgMKc3j9xJQnFCgcuS9eTk85YXxz6qpluJSTKyxhAedkniUJfumv4bP+niME3bLP
         n62c4i4tdRSxNHvbP+daCausiRWxaZUyqbEdw6in+bXpGR1/QYI29BOMeu51XL0nOMJ9
         WU8y2bNJaNLM4rWYErd5E7cFwDTa0wFKdFQ9zs1n1Gs75dFqcdm5nHuRrk3hEe7Fxm/z
         /9h65lOEPGcyct9CYhu8aYtzqzq8tpRxs4pYwy5AkIuTON4eiFUYy0X+DnZouWyVcXyd
         UeRLrB/BZMRGS8rII6Ez7JBGAfJKPIHhvIjArMTyet8NYeUiPtAx5wIu/IYnVFb2idSa
         izcg==
X-Gm-Message-State: AO0yUKXs4lP8u+M7ui1X5kM/1KwZBN3LqV8iCckaZv1WEJbItlS9a6mG
        nUKjCUy+bUE5zRYdO/wQ/4AR/VOj4O5grTNndqqkPrH7kY+ftoy0f7ogmhZYO0w4JvNmlZEeu1o
        UZeEtCTZwV70pGcR3qJiWl7uhE5P9PGex
X-Received: by 2002:a81:c606:0:b0:541:9063:8e9e with SMTP id l6-20020a81c606000000b0054190638e9emr6718626ywi.2.1679158021219;
        Sat, 18 Mar 2023 09:47:01 -0700 (PDT)
X-Google-Smtp-Source: AK7set+rZlNNlhk4MrnUetMXhvVweBbW+8ZF7JgSHuyec/P3LqLIpKIpqcDqgix6TH+ghfQfk3YFcI6V4M3cDz46W+I=
X-Received: by 2002:a81:c606:0:b0:541:9063:8e9e with SMTP id
 l6-20020a81c606000000b0054190638e9emr6718619ywi.2.1679158020965; Sat, 18 Mar
 2023 09:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230316120142.94268-1-donald.hunter@gmail.com>
 <20230316120142.94268-2-donald.hunter@gmail.com> <20230317215038.71ed63d7@kernel.org>
In-Reply-To: <20230317215038.71ed63d7@kernel.org>
From:   Donald Hunter <donald.hunter@redhat.com>
Date:   Sat, 18 Mar 2023 16:46:50 +0000
Message-ID: <CAAf2ycm760m7djm=XPtiZ5fnj3cx_GgLanAMAAh3tpNUJbQF2w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] tools: ynl: add user-header and struct
 attr support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Mar 2023 at 04:50, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Mar 2023 12:01:41 +0000 Donald Hunter wrote:
> > Subject: [PATCH net-next v1 1/2] tools: ynl: add user-header and struct attr support
>
> The use of "and" usually indicates it should be 2 separate patches ;)

Ack. I'll try and split it into two.

> > +  user-header:
> > +    description: Name of the struct definition for the user header for the family.
> > +    type: string
>
> Took me a minute to remember this is header as in protocol header
> not header as in C header file :) Would it possibly be better to call it
> fixed-header ? Can't really decide myself.

I went with user header because the generic netlink howto calls it the
"optional user specific message header" but happy to go with fixed-header.

> But the description definitely need to be more verbose:
>
> description: |
>   Name of the structure defining the fixed-length protocol header.
>   This header is placed in a message after the netlink and genetlink
>   headers and before any attributes.

Agreed, this is a much clearer description.

> > +    def as_array(self, type):
> > +        format, _ = self.type_formats[type]
> > +        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
>
> The Python is strong within you :)
>
> > +    def as_struct(self, members):
> > +        value = dict()
> > +        offset = 0
> > +        for m in members:
> > +            type = m['type']
>
> Accessing the spec components directly is a bit of an anti-pattern,
> can we parse the struct description into Python objects in
> tools/net/ynl/lib/nlspec.py ?

Ack, will do.

> > +            format, size = self.type_formats[type]
> > +            decoded = struct.unpack_from(format, self.raw, offset)
> > +            offset += size
> > +            value[m['name']] = decoded[0]
> > +        return value
> > +
> >      def __repr__(self):
> >          return f"[type:{self.type} len:{self._len}] {self.raw}"
> >
> > @@ -200,7 +220,7 @@ def _genl_msg(nl_type, nl_flags, genl_cmd, genl_version, seq=None):
> >      if seq is None:
> >          seq = random.randint(1, 1024)
> >      nlmsg = struct.pack("HHII", nl_type, nl_flags, seq, 0)
> > -    genlmsg = struct.pack("bbH", genl_cmd, genl_version, 0)
> > +    genlmsg = struct.pack("BBH", genl_cmd, genl_version, 0)
>
> Should also be a separate patch

Yep, I will separate this into its own patch.

> >      return nlmsg + genlmsg
> >
> >
> > @@ -258,14 +278,22 @@ def _genl_load_families():
> >
> >
> >  class GenlMsg:
> > -    def __init__(self, nl_msg):
> > +    def __init__(self, nl_msg, extra_headers = []):
> >          self.nl = nl_msg
> >
> >          self.hdr = nl_msg.raw[0:4]
> > -        self.raw = nl_msg.raw[4:]
> > +        offset = 4
> >
> > -        self.genl_cmd, self.genl_version, _ = struct.unpack("bbH", self.hdr)
> > +        self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
> >
> > +        self.user_attrs = dict()
> > +        for m in extra_headers:
> > +            format, size = NlAttr.type_formats[m['type']]
> > +            decoded = struct.unpack_from(format, nl_msg.raw, offset)
> > +            offset += size
> > +            self.user_attrs[m['name']] = decoded[0]
>
> user_attrs?

Um, attrs of the user-header. I'll try to name this better.

> > +        self.raw = nl_msg.raw[offset:]
> >          self.raw_attrs = NlAttrs(self.raw)
> >
> >      def __repr__(self):
> > @@ -315,6 +343,7 @@ class YnlFamily(SpecFamily):
> >              setattr(self, op.ident_name, bound_f)
> >
> >          self.family = GenlFamily(self.yaml['name'])
> > +        self._user_header = self.yaml.get('user-header', None)
> >
> >      def ntf_subscribe(self, mcast_name):
> >          if mcast_name not in self.family.genl_family['mcast']:
> > @@ -358,7 +387,7 @@ class YnlFamily(SpecFamily):
> >                  raw >>= 1
> >                  i += 1
> >          else:
> > -            value = enum['entries'][raw - i]
> > +            value = enum.entries_by_val[raw - i]['name']
>
> Also a separate fix :S

Ack, will do.

