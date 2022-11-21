Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B206319AB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 07:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiKUGPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 01:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKUGPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 01:15:05 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D022D1D329;
        Sun, 20 Nov 2022 22:15:04 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y4so9705866plb.2;
        Sun, 20 Nov 2022 22:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpCI5AhqSDdJiISgn77j94dYLn55Rs7iy+h5kkPtt5M=;
        b=jOg7gja4r9YEjUSLTIykjnFSAf03/0OgMoyurCm6NwrftpQN8NBjgdReA1+mScsjHs
         ZrmHOQgh2JcTJa03BiOBwKZp33xw5H9D4ZUiVoPMeVUBVm3cj0Gjp5bo2TLXe4w+Xtjm
         AWJwvDaGF2uZyYGsmshNLFpcouz98XoUXla4gAM+Xft94XqTiTGX4YvUNF4QtLaa/oIr
         EvHRhAS7w4/bt1EcPBfakfrq9lnt4ws5SjfA1Qc5cBgoJImxcYQDv2nIeP9Yhz6Zp49E
         NLOOZjeBh0lZaPogM6ijopmFU6cH0Q21ipIhw2V58MlVB6ZzW+KpecPcioyWGlE5CUQl
         wFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HpCI5AhqSDdJiISgn77j94dYLn55Rs7iy+h5kkPtt5M=;
        b=KmIRUTAEqIgOH3vG2t4zubxQDa7J41YAZQs6wfgQLFp42jsmOa/wtWw8qvzOwyusby
         xahBwdw0Gc9aL5g0fkOuhkAFcn+lbSVuV2EMfkkEcnCiosMRpjwXZTm7Laa4c3lm4k6I
         StQEEq/u+5xWQuKNhWfT8VuSPtp7SnJcuG4MhcR+xfqUoHNdRwirGf/TMPonW/E9PeQ1
         py06aIcwqtL28z6AqJiqum+bMsiNTD2LbiThsfXs+V17qf8eU6rcfbox01/qYpe1H5eo
         VWXFMwhpxZFtjwMGlGNl4AMWhiTr77m5CCbX51vVHNJfcahru5YqiL3NnUTUJ6HYewYr
         pjWQ==
X-Gm-Message-State: ANoB5plf7+XPxY2vcD6HR8RJinYoUqYyrQ9L0enXIwAKlZ+agkHe4fic
        yixDRG8+p8NApjOlJGBu1A2BmvxUmPU=
X-Google-Smtp-Source: AA0mqf5HFvWVaPrv62HGcKADGGpSSwU2K2PbHNNqBoDrI+ZPLcRpHyic7lKLmdXsg+UTbt40QmhW9g==
X-Received: by 2002:a17:902:e94e:b0:186:5613:becf with SMTP id b14-20020a170902e94e00b001865613becfmr1037460pll.46.1669011304290;
        Sun, 20 Nov 2022 22:15:04 -0800 (PST)
Received: from localhost ([2605:59c8:6f:2810:8ccd:b278:6268:540])
        by smtp.gmail.com with ESMTPSA id c7-20020a170902d48700b0017f72a430adsm8832454plg.71.2022.11.20.22.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 22:15:03 -0800 (PST)
Date:   Sun, 20 Nov 2022 22:15:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Message-ID: <637b1766420fe_b7b2208b3@john.notmuch>
In-Reply-To: <20221118170655.505702e5@kernel.org>
References: <cover.1668727939.git.pabeni@redhat.com>
 <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
 <87pmdky130.fsf@toke.dk>
 <20221118170655.505702e5@kernel.org>
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 12:05:39 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> > FWIW, the original commit 2e0de6366ac1 was merged very quickly withou=
t
> > much review; so I'm not terribly surprised it breaks. I would persona=
lly
> > be OK with just reverting it...
> =

> +1

Also fine with reverting my fix was mainly there to fix a CI test
that was failing. Apparently my quick fix wasn't nearly good enough.=
