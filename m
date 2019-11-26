Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3BB10A25F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfKZQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:43:39 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:32776 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfKZQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:43:39 -0500
Received: by mail-qv1-f68.google.com with SMTP id x14so7581511qvu.0;
        Tue, 26 Nov 2019 08:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KhtA9rIXQXlNV4fQ7BqQSdVc8vKs6lkf7nkcaD0QNF4=;
        b=LiImRZD+xfZ3IAzkqOnhJ6Wg3r6nQIwN79W130V6fXYY1bnILHPRse0aWy0TTCOBMc
         tqSmPCek/nl4knYns2V7+hKDw1mx96aYsHPf/1r7yvxoGWCU4yjlPXgH9rPmwNL/MKHh
         uf6zr5rxTv3+G2McmIn1E4jPOqSHQ1TrBBiknK7lTct3fXHHHmuhPR+AgMDOdf1RiGBA
         HTHN2H9ILqvPvIaW+JgwgjjvAjehktnIcDJ62S/GaFTj4PPUy4K0VIvH1RpU4zIT9pNQ
         hatSLCLokVZeIqDYv6ggp/pcbJaAMvlec/w0C8p4ZS7cWfmf+iioy87xDxAElUVjc14Q
         qCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KhtA9rIXQXlNV4fQ7BqQSdVc8vKs6lkf7nkcaD0QNF4=;
        b=WCH/cSfPNQ4+cW98nfln1pA6nmOFgXBdLTuS4WZkMRUCMx1ygGQjxm/oAhwEleM8iw
         Zu0Oeyfm6OZPzfiTNSWlGdYXPcAoBfq42aHhSj17Y1684PvZmRc6auq9nfewvISpYqAW
         TM8V/HIJP6PP/Hj0t+IIoZfVyIFH+roQWJQv0Vvp5Is6xJHBnh0yIJSifW0aD3/tPhrT
         YtZn3i5DCuGHZjLyCgKlQ/BcU8Pyx2x1Bg1pe6wFBmNtYf2HBIpLYB/iL1BQSoL//iui
         vPz2QPovZJB91BKwhVd3QH/WfoFfvDKEsFr+Gf3YZ5Tn1V+GlOvVhyfiGN27hsTxqv9R
         YzPQ==
X-Gm-Message-State: APjAAAWvKkAqU0C/dq5GtdWakrd6xL2H8Wss/I4fl8UIwiJ98InudK7a
        VXshrwk6AwcNgmL63WfDwCwKlqA8bhB/1Vlcl9g=
X-Google-Smtp-Source: APXvYqyq/GXZX7yyMNA8vGtvbY6ac+kEF+SEwTmtTMCRiJ3Dmjd3mK5Drs42n+6p2OBtOym0w7lnnSnQ5lb8DzvqBIg=
X-Received: by 2002:a05:6214:208:: with SMTP id i8mr19822372qvt.233.1574786617862;
 Tue, 26 Nov 2019 08:43:37 -0800 (PST)
MIME-Version: 1.0
References: <mhng-0a2f9574-9b23-4f26-ae76-18ed7f2c8533@palmer-si-x1c4>
 <87d0yoizv9.fsf@xps13.shealevy.com> <87zi19gjof.fsf@xps13.shealevy.com>
 <CAJ+HfNhoJnGon-L9OwSfrMbmUt1ZPBB_=A8ZFrg1CgEq3ua-Sg@mail.gmail.com> <87o8wyojlq.fsf@xps13.shealevy.com>
In-Reply-To: <87o8wyojlq.fsf@xps13.shealevy.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 26 Nov 2019 17:43:26 +0100
Message-ID: <CAJ+HfNiq9LWA1Zmf_F9j23__K2_NqcfQqRA5evGVP5wGzi881w@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Load modules within relative jump range of the
 kernel text.
To:     Shea Levy <shea@shealevy.com>
Cc:     linux-riscv@lists.infradead.org, albert@sifive.com,
        LKML <linux-kernel@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 at 14:25, Shea Levy <shea@shealevy.com> wrote:
>
> Hi Bj=C3=B6rn,
>
> Unfortunately I'm not sure what more is needed to get this in, and I'm
> in the middle of a move and won't have easy access to my RISC-V setup
> for testing. I don't think you can count on me for this one.
>

Thanks for getting back quickly! No worries, I'll pick it up!


Cheers,
Bj=C3=B6rn
