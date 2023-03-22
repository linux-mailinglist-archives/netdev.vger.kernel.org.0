Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652A96C49B7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCVLzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCVLze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:55:34 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4285E4B80E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:33 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id g9so11947641qvt.8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679486132;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n0vF+pKLJpcFHjG3C8iB+TP7mI+Cq5I8OPg4ObyYwYo=;
        b=SFm3JANNZDyH25SV2JjwikpK+Amtm60ee3R60RTBiGYOuPVjOylTGsadcuBvlVaf8N
         5IgzK2xE/h03IJOcTyw/423lc1TQYhDmgJhihqu3AyTg0ZSJgzszJLfq1uQlCdMycYiA
         2SYS1ptc0N8ySguGxGrAqUa6t0IcbF17HaqBNU5MEDjp2vl1mRrvrK7+S3cfGP+TZ22E
         d2e4fDo3kcRE6P6mvyACEOBgns2ykp2meDLQwQiRIHxpxf60k8e3rMPJ/+5v+EEHRHUE
         zCWgP4Da28HMOTBencSO5WZ5RRBC50bYppi6vEPlet7l/oflf5cqn2VPOG91BfkZYgAv
         liow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679486132;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0vF+pKLJpcFHjG3C8iB+TP7mI+Cq5I8OPg4ObyYwYo=;
        b=lRNDTJIRBm+FEhGJori/Aonjj16kreNJafpR6DfRpZsHY4bnr0gIjmgqDCDSL4CfWw
         qrUhSkqTiXPksuGubVu5Gr3wckwdC5acPWtCxVEuFak2oWn4qrXqyxLVJn8D4aGM5YZf
         tKBtGJBtP704Z9z8XIP4SHKcTKFn7swmK2IjHabec9DKjYEaoYfQnwJgEOqRMdL1Beup
         KdlTMBu3BPGARl77eiBiGAJuryPFWS09+jrtgWJhyfbfQFgnwwBeZskuitxdJ3ISVXOX
         M4qDwNmGVk1AR6h3k0TJiNlZSjwuYee+TtYPo8FjsrSoF0rNoscbu4/xgbw0DpIxWXqA
         zrRw==
X-Gm-Message-State: AO0yUKVlTAnAYOqv8ICnqRn7sabQZzyL8yUJ3XouB1YmYBh18e75P8m4
        VfzGbktDv+8I9hg6FSTFdrUhVQgcaTAtOA==
X-Google-Smtp-Source: AK7set/iGxi56SCHFXiLimjWWzgj9UdoQcgKTka6bcYwUTh9gsaj5RjB8wEoXkwjzVT6aOPbU3QqtA==
X-Received: by 2002:a05:6214:29e4:b0:5ab:56d4:dc43 with SMTP id jv4-20020a05621429e400b005ab56d4dc43mr5073049qvb.7.1679486132146;
        Wed, 22 Mar 2023 04:55:32 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id 201-20020a3708d2000000b007456efa7f73sm6353509qki.85.2023.03.22.04.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:55:31 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 3/6] tools: ynl: Add array-nest attr
 decoding to ynl
In-Reply-To: <20230321221809.26293ca7@kernel.org> (Jakub Kicinski's message of
        "Tue, 21 Mar 2023 22:18:09 -0700")
Date:   Wed, 22 Mar 2023 11:27:25 +0000
Message-ID: <m2fs9xjaaq.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-4-donald.hunter@gmail.com>
        <20230321221809.26293ca7@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sun, 19 Mar 2023 19:38:00 +0000 Donald Hunter wrote:
>> Add support for decoding nested arrays of scalars in netlink messages.
>
> example?

OVS_VPORT_ATTR_UPCALL_PID is a C array of u32 values. I can provide that
as an example in the commit message.

>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>> ---
>>  tools/net/ynl/lib/ynl.py | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
>> index 32536e1f9064..077ba9e8dc98 100644
>> --- a/tools/net/ynl/lib/ynl.py
>> +++ b/tools/net/ynl/lib/ynl.py
>> @@ -93,6 +93,10 @@ class NlAttr:
>>      def as_bin(self):
>>          return self.raw
>>  
>> +    def as_array(self, type):
>> +        format, _ = self.type_formats[type]
>> +        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
>
> So in terms of C this treats the payload of the attr as a packed array?
> That's not what array-nest is, array-nest wraps every entry in another
> nlattr:
> https://docs.kernel.org/next/userspace-api/netlink/genetlink-legacy.html#array-nest
>
> It's not a C array dumped into an attribute.
>
> IIRC I was intending to use 'binary' for packed arrays. Still use
> sub-type to carry the type, but main type should be 'binary'.
>
> If that sounds reasonable could you document or remind me to document
> this as the expected behavior? Sub-type appears completely undocumented
> now :S

That sounds reasonable, yes. I will also rename the method to
'as_c_array'. I think it should just be restricted to scalar subtypes,
i.e. u16, u32, etc. Do you agree?

I will update the  documentation for this.
