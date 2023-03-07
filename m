Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F4C6AF7F5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCGVtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCGVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:49:02 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6097A56164;
        Tue,  7 Mar 2023 13:48:52 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id p13-20020a9d744d000000b0069438f0db7eso7979658otk.3;
        Tue, 07 Mar 2023 13:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678225731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUlngX+gVwSHPtswH8naBfzXggCFw5mv1eC4zSHTGOo=;
        b=B/aB+Sh+lhHgTsna3rWAOtuTmje1B1cuwBcAu+D8qZ1dMQFZ2Zdl/h6uM5ECRykzwS
         BO1WwJjzkiXGjH+S6FvzLCqBQ64E5bv8trxjz6r8XY3qIPLTgrWLi4gE9VcadMyYuN2V
         Ue3t09iq8+I9W79bcjpfpVqY8DOhUkAM+cQtiK/mWFpSNw44wk+Sy44e2jpoKmb20rdd
         d8aiFNSWmku+c47glwuX/+JnQMaqA5In/g4viPhPCaD5/UTL6Apa80wu+EEH9gSXOCHc
         vIHu6BTW2LLqOhMaoI08sdNIFy+gjEoT7BpanvXs5zGL2+MrYD1wiIbvUlw6EXTPxJ7H
         ke+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678225731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUlngX+gVwSHPtswH8naBfzXggCFw5mv1eC4zSHTGOo=;
        b=s5HtV9dB2e8aWinTVYLuhm0GV59TxTpfEOHY0ybLTJPb/hWcjZGSpWi6kZc9tB9jSe
         fd7EmWVsYRzeT6NeQ09xh5kBkTrPSl/ikfvPO++FmXwzdZowm3PZ4/Ccuugd7Q/0jrfg
         EbSBZdPtxVXTZT+MZ1LnGf3xrj0Ja2BOWHyV3kjyxvkXbxSj5/EWAYpsadnKQwqSRVPz
         AlLa3weczgHwpbXCQnKh0KBqEKj++K/OFeCZkMTtX41eGoOsJ837VPFBky3SH3jxZhIn
         WOjr/+j0MUhxa9JKX7QgVWFzBCo1rPdmIVx5MOS0hbQufqiIJNT35RSGBtGeKWXUBfwI
         Gozg==
X-Gm-Message-State: AO0yUKVne08w9dm40ai7X69+GEazgFc0Ov1Usukiu+KQxhLycAlnBQEE
        ckM95JZTYVzd7J0XaA7UVhrOvt/0xp4XMw==
X-Google-Smtp-Source: AK7set+N+27PANrp2M3k38u/jfKLPhEQqgCAN4su4eBnoseDq7lnSrBHj3Y+0O56otp6nyTW/SUVYA==
X-Received: by 2002:a05:6830:3152:b0:693:c521:f40b with SMTP id c18-20020a056830315200b00693c521f40bmr8272751ots.16.1678225731459;
        Tue, 07 Mar 2023 13:48:51 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:d911:6e2b:27bc:8934:2423])
        by smtp.gmail.com with ESMTPSA id f15-20020a056830204f00b00690e7b0f9e3sm3058007otp.34.2023.03.07.13.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:48:51 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DF9314EDE7D; Tue,  7 Mar 2023 18:48:48 -0300 (-03)
Date:   Tue, 7 Mar 2023 18:48:48 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next 1/2] sctp: add fair capacity stream scheduler
Message-ID: <ZAexQCrc/5rmE1iw@t14s.localdomain>
References: <cover.1678224012.git.lucien.xin@gmail.com>
 <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:23:26PM -0500, Xin Long wrote:
> As it says in rfc8260#section-3.5 about the fair capacity scheduler:
> 
>    A fair capacity distribution between the streams is used.  This
>    scheduler considers the lengths of the messages of each stream and
>    schedules them in a specific way to maintain an equal capacity for
>    all streams.  The details are implementation dependent.  interleaving
>    user messages allows for a better realization of the fair capacity
>    usage.
> 
> This patch adds Fair Capacity Scheduler based on the foundations added
> by commit 5bbbbe32a431 ("sctp: introduce stream scheduler foundations"):
> 
> A fc_list and a fc_length are added into struct sctp_stream_out_ext and
> a fc_list is added into struct sctp_stream. In .enqueue, when there are
> chunks enqueued into a stream, this stream will be linked into stream->
> fc_list by its fc_list ordered by its fc_length. In .dequeue, it always
> picks up the 1st skb from stream->fc_list. In .dequeue_done, fc_length
> is increased by chunk's len and update its location in stream->fc_list
> according to the its new fc_length.
> 
> Note that when the new fc_length overflows in .dequeue_done, instead of
> resetting all fc_lengths to 0, we only reduced them by U32_MAX / 4 to
> avoid a moment of imbalance in the scheduling, as Marcelo suggested.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
