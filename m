Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7F65C2E6
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbjACPUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbjACPUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:20:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1E10544
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 07:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672759193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8tFVbE4QN6qhi0O2aBkIXiBf6pHY8zcS3cdBJgDR0kE=;
        b=GblZlRHi6xabx+mTvEmIzzTOLReTElsnxTfFPeduv7PqLbY29XewupPvhpwptBRak5annz
        7/7KxKHex8G4LDg4cR4BORHSn2ao/nnYRhY9QLW+A4aQc5auVN6BWTkG9azu7s8QkdNKbX
        r5mw/SdiS3LSFh9FQjFJB8tlUArWq8k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-13-L1sGQApyNnqpsBgiCTV92A-1; Tue, 03 Jan 2023 10:19:52 -0500
X-MC-Unique: L1sGQApyNnqpsBgiCTV92A-1
Received: by mail-ed1-f70.google.com with SMTP id h8-20020a056402280800b0046af59e0986so20158594ede.22
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 07:19:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tFVbE4QN6qhi0O2aBkIXiBf6pHY8zcS3cdBJgDR0kE=;
        b=bHf0yNvgon2OnfH2a7WSPZ5c353CzE4WLCu474VnCgjF8hfANjXKr0UoOrquA+Wz9I
         /pxybcgtVUy6PAwDxTEHd+gC6231HiIJRzmf1C8dDJwvNJ0DO4O0badlB0XoIYCnU5na
         HEVHPFMUmt7sC7iTB8yxMK2aeOJ7kowu/j5QU4GGYGZuaS361nHbUeyn4xxor9rjKRxy
         fSVbuzHSsApwvOfhfk+sqD3ZOIjJl1S9+VAtnysmH//s3Hn65mPKkHsIfqamUfyWTst/
         qMbq3hM7HW3vD39+Gr/v1w19GjBNBQ+7EuoCWPm6xCFHgwi5iZpQnccPe0DbPiiQxwlE
         Vhaw==
X-Gm-Message-State: AFqh2krTE+k4bW64BR+USUnxCnbpj3dHN8Ue6FDBbeq7zYkjs4gX6DIw
        aQ/wZYubA1/6pV3En1j2WdtTfGpXT8Yy8S7OOXX1hAXWwzukZ0UhxwxSLahsbCmAhTjs4JyWusU
        69lAOB21EbgaA7TBm
X-Received: by 2002:a05:6402:685:b0:470:25cf:99d1 with SMTP id f5-20020a056402068500b0047025cf99d1mr38395927edy.31.1672759191010;
        Tue, 03 Jan 2023 07:19:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsXKEhPwpG4WD26/S8ItwuDbPLpP1zllLWTgdQUjI2l22k2Bionu0USrmbqSUGT5LdKx5RBsQ==
X-Received: by 2002:a05:6402:685:b0:470:25cf:99d1 with SMTP id f5-20020a056402068500b0047025cf99d1mr38395894edy.31.1672759190722;
        Tue, 03 Jan 2023 07:19:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id co5-20020a0564020c0500b00483dd234ac6sm11424853edb.96.2023.01.03.07.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:19:50 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44CE68A2678; Tue,  3 Jan 2023 16:19:49 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
In-Reply-To: <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 03 Jan 2023 16:19:49 +0100
Message-ID: <87k0234pd6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq Toukan <ttoukan.linux@gmail.com> writes:

> On 21/06/2022 20:54, Andy Gospodarek wrote:
>> This changes the section name for the bpf program embedded in these
>> files to "xdp.frags" to allow the programs to be loaded on drivers that
>> are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
>> the buffers, the packet data is now accessed via xdp helper functions to
>> provide an example for those who may need to write more complex
>> programs.
>> 
>> v2: remove new unnecessary variable
>> 
>
> Hi,
>
> I'm trying to understand if there are any assumptions/requirements on 
> the length of the xdp_buf linear part when passed to XDP multi-buf programs?
> Can the linear part be empty, with all data residing in the fragments? 
> Is it valid?
>
> Per the proposed pattern below (calling bpf_xdp_load_bytes() to memcpy 
> packet data into a local buffer), no such assumption is required, and an 
> xdp_buf created by the driver with an empty linear part is valid.
>
> However, in the _xdp_tx_iptunnel example program, it fails (returns 
> XDP_DROP) in case the headers are not in the linear part.

Hmm, good question! I don't think we've ever explicitly documented any
assumptions one way or the other. My own mental model has certainly
always assumed the first frag would continue to be the same size as in
non-multi-buf packets.

I do seem to recall there was some discussion around this when we were
discussing whether or not we needed programs to explicitly opt-in to
multi-buf support (what ended up being the "xdp.frags" section). The
reason we said it might *not* be necessary to do that was that most
programs would just continue working, and it would only be those that
either tried to access the end of the packet, or to compute the packet
length as data_end-data that would need any changes before enabling
the frags flag. Which also kinda implies that headers etc would continue
to be in the linear part.

This is all from memory, though, so maybe others have different
recollections. In any case this is probably something we should document
somewhere :)

-Toke

