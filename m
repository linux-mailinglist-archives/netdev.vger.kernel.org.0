Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2811FDFAA
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfKOOHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:07:49 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44886 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbfKOOHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 09:07:49 -0500
Received: by mail-yb1-f193.google.com with SMTP id g38so4018019ybe.11
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 06:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42z/vN/ddc98lKOq1CrQyhubCI2S5NP9LWnyNiKPWxk=;
        b=nLefbRNHj5/Shr2PtahgWUegdQ/rJ1Elkczuy2ggEoMon0rguyVvdv5zG2g4GbWS22
         OKoqoHLjnz2BBXw6mw9LorWYAqDBialbZAo3pdWjuQiezMeqdXnL9zVWJcKnUh/jeXaz
         12pSlMxWFZf54uaw08IoqD2MkSSkl2J2YxZZsIKDWg7K5uBfXF1Eh2XOsUgGCenfvHLx
         RA5UxmckvhCoiP6L8YLtHOlFfJS6mYxlRpVs6BJrV4EiTapyfb2j4TFMuJhpf3FVvwj8
         sZpCikRN/qh1orYy9uyGebYzrxBDub8AAT2dgKwuc/7VqAMTNngS/YwVNZCTjGd9CSL7
         T2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42z/vN/ddc98lKOq1CrQyhubCI2S5NP9LWnyNiKPWxk=;
        b=TB+FVzFn4aRonbYFNGPmchtUy7RmNL1ioofKuiuYaWAMTkicugDYnAq0tWo+1SMBBW
         9VkOj33s4Lb/7q5NzGBEAbyF8sn2dz9NSx+NvvMryJdfiMpKC1BKImpokXFAIz4luMmr
         PUUNxzSfnR0DFbRNqbXGOyZ9EYgsbYB6iovQd9lrj3Hp9kPpQHpacQDtdOT+FFmHNC/W
         ZJuRMTZ8Tleasp+lu1zMRBFm89qnksNwUgxKePRblsa1xg2hFsuO9DLlsInGDUw5aDv3
         bCU1ETAxz/2x+6KBg5EdJ73E+r75eqbhAefLNZxN+sbGTZg8naTXyrlNwa42YwEd8DgA
         3vtA==
X-Gm-Message-State: APjAAAVMDgED8lIQAUoaxHHOYB7yl4TJoMPjVhJMs/rON5xCA7huXo++
        czq90CmKAsQALrOkOxHWkXGh0b6h
X-Google-Smtp-Source: APXvYqynkgUeSnmWPFwN0q5wUNtaIHI/0Sc0opiK33kwtT7FNx62PbzD08NgCfoe2bSV/x0BP/kusw==
X-Received: by 2002:a25:32c9:: with SMTP id y192mr10860647yby.96.1573826867292;
        Fri, 15 Nov 2019 06:07:47 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id 15sm3558321ywb.73.2019.11.15.06.07.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 06:07:46 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id z67so3095576ywb.9
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 06:07:45 -0800 (PST)
X-Received: by 2002:a0d:e808:: with SMTP id r8mr9316664ywe.275.1573826865311;
 Fri, 15 Nov 2019 06:07:45 -0800 (PST)
MIME-Version: 1.0
References: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
In-Reply-To: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 15 Nov 2019 09:07:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeWU7Tfg1SKotM4+r1NH+CH=Xei3Ho209xYm+DvuAneHw@mail.gmail.com>
Message-ID: <CA+FuTSeWU7Tfg1SKotM4+r1NH+CH=Xei3Ho209xYm+DvuAneHw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 7:43 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
> is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
> starting it again every time it is expected to terminate. The exception is
> the final client_connect: the server is not started anymore, which ensures
> no process is kept running after the test is finished.
>
> For a sit test, though, the script is terminated prematurely without the
> final client_connect and the 'nc' process keeps running. This in turn causes
> the run_one function in kselftest/runner.sh to hang forever, waiting for the
> runaway process to finish.
>
> Ensure a remaining server is terminated on cleanup.
>
> Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Yes, I had missed that the server gets restarted even though the SIT
test has to bail instead of run the last, BPF decap, test.

Thanks Jiri.
