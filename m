Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706A57DD49
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbfHAOEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:04:33 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37143 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730581AbfHAOEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:04:33 -0400
Received: by mail-yw1-f67.google.com with SMTP id u141so26166800ywe.4
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSXRx8sevkI1+Ct1jPLOSJRaspU7owFl2CB2FwyZ8Eo=;
        b=Qj3xg/2VB1GjcEU24FulBk+gL+CBBkyTm3VbNTNqdDfua/1PB/vf6RXMH1GJbeuVYT
         DI9GQKFH2a99rR9IaJ82AFuoC9gtqKOCzzCRuM5dRZcvWUVOWDAU5cq//9+z35mKQLvE
         W9Qrh18MppD+f/rO3H9CElF5c97arJw5Q2sShlQL5wLRDEnE9HvDINWOvYLCElb+Tupy
         hKqtS09k5bbxP+DdB/EDnQnDDpV94P/V28pNUXA0F1vv5yOdZdVAPm8zPxDDfzajIFDJ
         EXM3rdgqkjx90JuG4rw0DXMRvQLqMJPgjnY+jycgdOtVDqAfcLPKxZ23+nq6FdXmVKCV
         3Rqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSXRx8sevkI1+Ct1jPLOSJRaspU7owFl2CB2FwyZ8Eo=;
        b=fQA7r7t61M9PhnCX1CGJCDHYdMh/OxOKrjSlRbjK6u/3I5PnjgKfZn+r6EgBZltFhA
         1IPI0ZZ8clngubdBZtiWSIM/vnmAgyA0S+wRlv1q1vhBR8n353U4AM95kHPJdhUJu5AK
         Ww9toMCqTffEn0HapdoHw+EGryeBMcrgI+peTwNg2fqUjaiBu3R92cdfBI7GjcPuofzW
         kKR1wcyAmplbpeNkcMXGx66bCa6KwsqySYJjt1sCec3uKw1dDr2hhQm5VqlL6LJJENQW
         v3ZZYMIDJSYleTjUMHfROYbTtX5YV1pb+nShyJnnxOAHj5bE0RymEALqkykqaWc0mWtK
         crkA==
X-Gm-Message-State: APjAAAVK+SXPR3JRkSlz78swgCg7LT/7zJynY/cHUPGA886YjJGUIsmo
        wYJR76u3RlNJFirV6EbJyCuPEoMz
X-Google-Smtp-Source: APXvYqwWLS9ilEOFOBLltUiLqnioIb9RtxlcDc9woJnG+LHb3llOTwVZATUm1VdnqSx9cLrPbABvQA==
X-Received: by 2002:a81:2981:: with SMTP id p123mr72581328ywp.430.1564668271727;
        Thu, 01 Aug 2019 07:04:31 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id a201sm16719498ywa.19.2019.08.01.07.04.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 07:04:30 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id m16so26160752ywh.12
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:04:30 -0700 (PDT)
X-Received: by 2002:a0d:c301:: with SMTP id f1mr74087982ywd.494.1564668270115;
 Thu, 01 Aug 2019 07:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190801092420.34502-1-dkirjanov@suse.com>
In-Reply-To: <20190801092420.34502-1-dkirjanov@suse.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 1 Aug 2019 10:03:53 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf27jFNn-4c+05y3WTkOkMbygriVcHXX-Lg_cUky1k4Ew@mail.gmail.com>
Message-ID: <CA+FuTSf27jFNn-4c+05y3WTkOkMbygriVcHXX-Lg_cUky1k4Ew@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] be2net: disable bh with spin_lock in be_process_mcc
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 5:24 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
> be_process_mcc() is invoked in 3 different places and
> always with BHs disabled except the be_poll function
> but since it's invoked from softirq with BHs
> disabled it won't hurt.

This describes the current state. What is the benefit of removing the
local_bh_disable/local_bh_enable pair from one caller (be_worker), but
not another (be_mcc_wait_compl) and then convert process_mcc to
disable bh itself with spin_lock_bh?
