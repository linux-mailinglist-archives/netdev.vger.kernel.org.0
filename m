Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DDE51965
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbfFXRRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:17:02 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:39980 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFXRRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:17:02 -0400
Received: by mail-io1-f44.google.com with SMTP id n5so3816908ioc.7;
        Mon, 24 Jun 2019 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HKVZVeTIp0VzP4z4Uro5y3TTUO1hlLUucOTNEWyo+tU=;
        b=kqK76VCJ2Tc+wIyI2JOQ/ZV6Fh/BExUX9pt0s72wbQbVVyV1s3YFexA2Gu8SlQXp/I
         EtwsZB2BoZlFJ983KZ+zCm7b6Hx46/GF4b2NSjWh7Cibsg0DXEe892VrJteOTB1cH4oX
         qtNqLS6uspEqD/Kv7ScBHkdRbALxcS/Lx/QzuVUazygm6YFZt1yG7WFkhytp0HSKX72H
         x0m2BId2noXj/eTO969WTKThIe7izvrU6zXhLBJ0b6nid0VrT2YnaAJLuR5+rju5cVwW
         mRvhGzNcNLwu+FZcbkOT1TVBV0gHEjmj9EuSB+Dy2PBTIzgnpRd31SbVOnGG3LWWElb2
         D5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HKVZVeTIp0VzP4z4Uro5y3TTUO1hlLUucOTNEWyo+tU=;
        b=sgl0e1leW2n3EZ7cZRckUajBpqBZtKtfiSewpfrsVKrZwt3Q9RqpL4/brTGPwTqZCk
         LMo3boGzDRIY2/kYnkK3SWCj4nWK83Kda4VEEKBD8/mQpSSS+Br7uJgNSUtzcZ8GWhpr
         gZ8SmyGCMYzlAhu8BLknD8I3jaQK9/1LDrYai9/kPb7EKNFVzp4tqg+ltiisRM222IGM
         ie7qhZV4T4xG+9IhjULrnsHDu72TjlVk6kcLFmm9gSuFbSyLHimquirODQsBZB0aRH8K
         E+PW3xAmkXrwHnHE+FB8hmfrZgI84arOHuEwV4Vp/N/RA9Yx0LTZpKD0Gz8ksM2NAGH+
         hrKw==
X-Gm-Message-State: APjAAAWwq5EVPbVz4LCiAcYQI9auYU3ies39Ocy23jJeBvG4fO5IeKWb
        r89Ek00fUj3cKyEKikz2VEZ/N2+7SHwt5bViAyw=
X-Google-Smtp-Source: APXvYqys+HijZUTbiXSyiQ6GHQWE2ih7NaysqfQN4H4DvhAB8KcMe+qfcJYvq6imH+Gw3Fh/B+mOTRB6JLhN8F9jSlk=
X-Received: by 2002:a5e:8f42:: with SMTP id x2mr15878117iop.35.1561396621141;
 Mon, 24 Jun 2019 10:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008f19f7058c10a633@google.com> <871rzj6sww.fsf@miraculix.mork.no>
 <87tvcf54qc.fsf@miraculix.mork.no>
In-Reply-To: <87tvcf54qc.fsf@miraculix.mork.no>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 24 Jun 2019 19:16:50 +0200
Message-ID: <CAKfDRXjnUZx2rAVV1-9em9YyNvJbFG+vciZHihsKiu66Uz2Dgw@mail.gmail.com>
Subject: Re: KASAN: global-out-of-bounds Read in qmi_wwan_probe
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com>,
        andreyknvl@google.com, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 24, 2019 at 6:26 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
> Doh! Right you are.  Thanks to both you and Andrey for quick and good
> help.
>
> We obviously have some bad code patterns here, since this apparently
> worked for Kristian by pure luck.

Thanks a lot to everyone for spotting and fixing my mistake, and sorry
for not replying earlier. The patch from Bj=C3=B8rn is probably a candidate
for stable as well. I don't remember exactly when the quirk was
accepted in the kernel, but I recently submitted and got the quirk
accepted into 4.14.

BR,
Kristian
