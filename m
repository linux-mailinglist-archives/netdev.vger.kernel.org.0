Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D731E4511
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgE0OCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730223AbgE0OCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:02:04 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86317C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:02:04 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id z80so24440569qka.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l1O0d/JFqWmOK/JTbtPRg3AVyVLD8AEijf3h9edlpcg=;
        b=np3N8AMzG9dAvh+qtla+MgtNb5lJALZT8em5MprncZi5huDwRjvjxMWJteywAfFw7J
         BHlYNTvJ2oG2IvAVFgCNIoNYNR33Mpi2B5toX3PH0Zp2xeL0RZhBpCcC3FQtNR4xC7mT
         AwP9fLmhK3o7v35qIJEQySzg/6UZWrK3YzwTG8q/dDO9mkZx+qNMnak442fSZRU6CDvD
         w8QGeH11zQIKOIoAVubyEnJFfF23wkeYkMEer357j+fTz8Rt4DqWcl9gMNFZdi1W1pct
         Bu4IJR/pzrsElOLpmzK6D1MXEDzzO1p+acBXPZIGdg8yhS01YSABhZ5JwvIOPtKftCsq
         FAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l1O0d/JFqWmOK/JTbtPRg3AVyVLD8AEijf3h9edlpcg=;
        b=DiwG8ua0WZmU6dCJ8iDgWnWRnh2pHURIgB5lgfDlppJYiYscy/mbUZIPGtiIuBKcNe
         4kL336lC7sHpAPl8MqZ7qxU+Ih6Zxruaa56dgTn/qIyXxOrC7Gz+kX+ikfj649sZz/yZ
         eIJPn4LmdbO1F2+zs3ZXgblLrlmsbJPMg4Fsin3kR/P3GFV+BbCjTY6OxEdct89jTuok
         MV7KX8huR/PRgHcbLc1AIC7ueihzWft8+g0qTY6h4MkJwkZ8HD7wgI/3yaFers+agcWM
         l7cl5ymn3TtOT2ZryCFhti/taL/VzUs8LgJ9b/GErCp/e7GAwl0dU2v180GRZgQu68y/
         c4Gg==
X-Gm-Message-State: AOAM531pAgX3cDdyhXHC7J08Gk9vRUaNQWH1jpzC6TMNhuG0BMiwfBEA
        SlXzs5tqTuXdlAEioCWaD1Q=
X-Google-Smtp-Source: ABdhPJxieUp0mHbXcmyLZ5mNbverWfav8jK7P0RIrW175uTYLeDwm0W7Pi+hu3mRE0cuL3OnR6Ti+Q==
X-Received: by 2002:a37:b57:: with SMTP id 84mr4012279qkl.364.1590588123770;
        Wed, 27 May 2020 07:02:03 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id c66sm2165163qkd.5.2020.05.27.07.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 07:02:02 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/5] bpf: Add support to attach bpf program to a
 devmap entry
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-3-dsahern@kernel.org> <875zch3de6.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <39fc3e35-49c6-3d47-e3fc-809f41998362@gmail.com>
Date:   Wed, 27 May 2020 08:02:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <875zch3de6.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 4:01 AM, Toke Høiland-Jørgensen wrote:
> Did you give any special consideration to where the hook should be? I'm
> asking because my immediate thought was that it should be on flush
> (i.e., in bq_xmit_all()), but now that I see this I'm so sure anymore.
> What were your thoughts around this?

I chose this spot for many reasons:

1. dev_map_enqueue has the bpf_dtab_netdev structure which holds the program

2. programs take xdp_buff, and dev_map_enqueue still has the xdp_buff
with the rx information; no need to convert from buff to frame losing rx
data, enqueue, back to buff to run program, back to frame to hand off to
the driver.

3. no sense enqueuing if the device program drops the frame.
