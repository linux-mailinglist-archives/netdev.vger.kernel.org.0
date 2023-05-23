Return-Path: <netdev+bounces-4601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9912B70D82A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00A702812A9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B241DDF6;
	Tue, 23 May 2023 09:00:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABE4C89
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:00:40 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5236B19B;
	Tue, 23 May 2023 02:00:35 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b17aa343dso95426685a.3;
        Tue, 23 May 2023 02:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684832434; x=1687424434;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2cPzg9poaujjMtbeHorOUZq64smNX+WhZmQWIdJd3y8=;
        b=dPFWtOkkLfJcqkT/0FsLf3MjGIOcxBTy5FZnApvnM+/f+PjUos1OKrJak4sK45KSlM
         jsonMzq4TrSSuKiJ4YnpYYH9Yn5X5VeV595MKoUIdrUGrXjaW6v7qEiDuBTtp2fBK0Zu
         DjZCsfNf3IrtL7/lDFqto/lHAzVDIseeT9D7MOJUBk7UWPDLBhkl8obcQHId1LdXVRFe
         BSTAh/zSWv6AA9yvVR6PQuJOr3A4QghbfMvJc5GI3hut8ZeivaTfwOPmb+Td8JARYv1G
         WunqKUl0uLG4NNquOLhoNGUGFHFU17X77Ilq56j5mm4A449/eOue1fC+p678fm+U9bDw
         rxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684832434; x=1687424434;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cPzg9poaujjMtbeHorOUZq64smNX+WhZmQWIdJd3y8=;
        b=GPcS2vFdgjj/ZxYI3Jx9VNajhxdb7SxAGeGL9xiqqxFVzqG1iCKyzez5FDdr58KRu8
         MkD7cRp2zO91f5uiq0dSv5emkrsNIva47aVOvXYrUl5TeWnPLPXOhparOqudWCsy85UL
         JG8ffi/hNuITMvjmUDJt6l3GgjwssV5kKLVjWR5g7F9ubCqxtdsPsU8ECfetiPf6wh6e
         a4djisJPIFm4yI/IXwyWgreGBIcwT8rgM9gTwQQzlLQoOBErleLlIgagH+EWtgFXVbQU
         /lVZe2wWyLD7hC8tA3N1rYo8txqsu458UFuVgM0XYVMEZsIs4t2RnIGJ5jefdGvqhwQ+
         oetg==
X-Gm-Message-State: AC+VfDwtdHYEVRPQOrTPAVGmT4gPKfsQZyQvQrnvxtTVGCIVZoV8q0MC
	lguVY9ajNZN2PpPBz0Q8rGlrIb00GMcGpWjb
X-Google-Smtp-Source: ACHHUZ5akESzGAk46qZwjWrbIC9a/BBtlpn/Hbxs4SrKPbf65nMgyvHtQ3Nzn0lNhiPr0nI0Wg1lBg==
X-Received: by 2002:a05:620a:460c:b0:75b:23a1:8334 with SMTP id br12-20020a05620a460c00b0075b23a18334mr3632009qkb.47.1684832434235;
        Tue, 23 May 2023 02:00:34 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id x25-20020a05620a01f900b00755951e48desm2325398qkn.135.2023.05.23.02.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:00:33 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Jonathan
 Corbet <corbet@lwn.net>,  linux-doc@vger.kernel.org,
  donald.hunter@redhat.com
Subject: Re: [patch net-next v1 1/2] tools: ynl: Use dict of predefined
 Structs to decode scalar types
In-Reply-To: <20230522193719.1428a3bf@kernel.org> (Jakub Kicinski's message of
	"Mon, 22 May 2023 19:37:19 -0700")
Date: Tue, 23 May 2023 09:21:20 +0100
Message-ID: <m2pm6rlapr.fsf@gmail.com>
References: <20230521170733.13151-1-donald.hunter@gmail.com>
	<20230521170733.13151-2-donald.hunter@gmail.com>
	<20230522193719.1428a3bf@kernel.org>
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

> On Sun, 21 May 2023 18:07:32 +0100 Donald Hunter wrote:
>> Use a dict of predefined Struct() objects to decode scalar types in native,
>> big or little endian format. This removes the repetitive code for the
>> scalar variants and ensures all the signed variants are supported.
>
>> @@ -115,17 +116,17 @@ class NlAttr:
>>          return self.raw
>>  
>>      def as_c_array(self, type):
>> -        format, _ = self.type_formats[type]
>> -        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
>> +        format = self.get_format(type)
>> +        return list({ x[0] for x in format.iter_unpack(self.raw) })
>
> I probably asked about this before, and maybe not the question 
> for this series but - why list({ ... }) and not [...]?

It looks like I cargo-culted something there, and it's just plain
wrong. Reading it now, it's clearly a set comprehension coerced into a
list, which could well change ordering.

I'll fix this in the next version.

>>          else:
>> -            raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
>> +            try:
>> +                format = NlAttr.get_format(attr['type'], attr.byte_order)
>> +                attr_payload = format.pack(int(value))
>> +            except:
>> +                raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
>
> Could we do:
>
> 	elif attr["type"] in NlAttr.type_formats:
>
> instead? Maybe my C brain treats exceptions as too exceptional..

Good suggestion, that's much cleaner.

>> +            elif attr_spec["type"]:
>> +                try:
>> +                    decoded = attr.as_scalar(attr_spec['type'], attr_spec.byte_order)
>> +                except:
>> +                    raise Exception(f'Unknown {attr_spec["type"]} with name {attr_spec["name"]}')
>
> Same here.

Ack.

> Nice cleanup!

