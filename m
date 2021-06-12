Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475313A5123
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFLWpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 18:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLWpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 18:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4834561078
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 22:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623537819;
        bh=goJ8aJR9Ya+hWT/awbHD8I6tvWjdOqmoIBdf/EsJyio=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VyOuWd6Nah+dFFNDCilXfVhwOsG5jrQ+r3Po1qf4QKQcN0SziTmTslwPG63Noxiwx
         7UH75cCHhW5PLv5QP/aihm3cNu4MgkEwIdInKPhhqZ26HLd9uJZYg0VFzGO/6T00Kv
         NIM81jVTeDepsHEJttmuCwpd8yC8L7DxIKdALW2ecYUV3SkLyV488NBourFnf94fjT
         kXhs+0/oCeJrL7s/Sy5lU2e9Fp7cVRXx6uAUnBZBg1/ag/9Mi5bFa1B11/MuAbhbO6
         0NA3ZIOGtZa93Ii3bdsyhD8gFMUIXMyKG7LHekmeZiREJry+JjOrcpiVLjZAVLgej5
         j/tutTJ/EiyiQ==
Received: by mail-wm1-f41.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso10615903wmi.3
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 15:43:39 -0700 (PDT)
X-Gm-Message-State: AOAM5332vZ480WMo90EYfkYwSO+yEn5ZssDdbmdpUPZ181NT/RJCyu4Z
        W90IkgRejHtwjJFrAhfZQx9aaDdcOFiE8+8Bb24=
X-Google-Smtp-Source: ABdhPJx6bkxDm8JA+Xxfkq0TiazT1E/ulUI2EWqwStjwKpL/A7K7zE0asPM567xX7qT07O2iKsK+QdR6R4EDpxTAe5U=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr26125872wmb.142.1623537817912;
 Sat, 12 Jun 2021 15:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B36A9A.4010806@gmail.com>
 <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
 <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
 <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
 <60BFEA2D.2060003@gmail.com> <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
 <60C4F187.3050808@gmail.com>
In-Reply-To: <60C4F187.3050808@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 13 Jun 2021 00:41:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3vnnaYf6+v9N1WmH0N7uG55DrC=Hy71mYi4Kt+FXBRuw@mail.gmail.com>
Message-ID: <CAK8P3a3vnnaYf6+v9N1WmH0N7uG55DrC=Hy71mYi4Kt+FXBRuw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 7:40 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> 09.06.2021 10:09, Arnd Bergmann:
> [...]
> > If it's only a bit slower, that is not surprising, I'd expect it to
> > use fewer CPU
> > cycles though, as it avoids the expensive polling.
> >
> > There are a couple of things you could do to make it faster without reducing
> > reliability, but I wouldn't recommend major surgery on this driver, I was just
> > going for the simplest change that would make it work right with broken
> > IRQ settings.
> >
> > You could play around a little with the order in which you process events:
> > doing RX first would help free up buffer space in the card earlier, possibly
> > alternating between TX and RX one buffer at a time, or processing both
> > in a loop until the budget runs out would also help.
>
> I've modified your patch so as to quickly test several approaches within
> a single file by just switching some conditional defines.
> My diff against 4.14 is here:
> https://pastebin.com/mgpLPciE
>
> The tests were performed using a simple shell script:
> https://pastebin.com/Vfr8JC3X
>
> Each cell in the resulting table shows:
> - tcp sender/receiver (Mbit/s) as reported by iperf3 (total)
> - udp sender/receiver (Mbit/s) as reported by iperf3 (total)
> - accumulated cpu utilization during tcp+upd test.
>
> The first line in the table essentially corresponds to a standard
> unmodified kernel. The second line corresponds to your initially
> proposed approach.
>
> All tests run with the same physical instance of 8139D card against the
> same server.
>
> (The table best viewed in monospace font)
> +-------------------+-------------+-----------+-----------+
> | #Defines          ; i486dx2/66  ; Pentium3/ ; PentiumE/ |
> |                   ; (Edge IRQ)  ;  1200     ; Dual 2600 |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 1  ;             ; tcp 86/86 ; tcp 94/94 |
> | TX_WORK_IN_POLL 0 ;  (fails)    ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 0     ;             ; cpu 59%   ; cpu 15%   |
> | LOOP_IN_POLL 0    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 0  ; tcp 9.4/9.1 ; tcp 88/88 ; tcp 95/94 |
> | TX_WORK_IN_POLL 1 ; udp 5.5/5.5 ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 0     ; cpu 98%     ; cpu 55%   ; cpu 19%   |
> | LOOP_IN_POLL 0    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 0  ; tcp 9.0/8.7 ; tcp 87/87 ; tcp 95/94 |
> | TX_WORK_IN_POLL 1 ; udp 5.8/5.8 ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 0     ; cpu 98%     ; cpu 58%   ; cpu 20%   |
> | LOOP_IN_POLL 1    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 1  ; tcp 7.3/7.3 ; tcp 87/86 ; tcp 94/94 |
> | TX_WORK_IN_POLL 0 ; udp 6.2/6.2 ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 1     ; cpu 99%     ; cpu 57%   ; cpu 17%   |
> | LOOP_IN_POLL 0    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 1  ; tcp 6.5/6.5 ; tcp 88/88 ; tcp 94/94 |
> | TX_WORK_IN_POLL 1 ; udp 6.1/6.1 ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 1     ; cpu 99%     ; cpu 55%   ; cpu 16%   |
> | LOOP_IN_POLL 1    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
> | TX_WORK_IN_IRQ 1  ; tcp 5.7/5.7 ; tcp 87/87 ; tcp 95/94 |
> | TX_WORK_IN_POLL 1 ; udp 6.1/6.1 ; udp 96/96 ; udp 96/96 |
> | LOOP_IN_IRQ 1     ; cpu 98%     ; cpu 56%   ; cpu 15%   |
> | LOOP_IN_POLL 0    ;             ;           ;           |
> +-------------------+-------------+-----------+-----------+
>
> Hopefully this helps to choose the most benefical approach.

I think several variants can just be eliminated without looking
at the numbers:

- doing the TX work in the irq handler (with the loop) but not in
  the poll function is incorrect with the edge interupts, as it has
  the same race as before, you just make it much harder to hit

- doing the tx work in both the irq handler and the poll function
  is probably not helpful, you just do extra work

- calling the tx cleanup loop in a second loop is not helpful
  if you don't do anything interesting after finding that all
  TX frames are done.

For best performance I would suggest restructuring the poll
function from your current

  while (boguscnt--) {
       handle_rare_events();
       while (tx_pending())
             handle_one_tx();
  }
  while (rx_pending && work_done < budged)
         work_done += handle_one_rx();

to something like

   handle_rare_events();
   do {
      if (rx_pending())
          work_done += handle_one_rx();
      if (tx_pending())
          work_done += handle_one_tx();
   } while ((tx_pending || rx_pending) && work_done < budget)

This way, you can catch the most events in one poll function
if new work comes in while you are processing the pending
events.

Or, to keep the change simpler, keep the inner loop in the tx
and rx processing, doing all rx events before moving on
to processing all tx events, but then looping back to try both
again, until either the budget runs out or no further events
are pending.

      Arnd
