Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10ABE1A2A38
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgDHUSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:18:51 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:33054 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgDHUSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:18:51 -0400
Received: by mail-ot1-f53.google.com with SMTP id 103so1766961otv.0
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 13:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O9OQLWU+L8cw2kQ65uVTWLezhpLVOU7vvKIvyjvb5go=;
        b=fAH7nGvu5Ex9ePvBMLwGYHM+yNT4lIfyeI5YvP/rD2QCacGZJ/07c/Of0SNxmniQmt
         fgn0ig3599QRzFy8jsHw8vyallXVP3vSgeI+LT+9/OoY9A3WWqZOlvPXoVPAS8a3E9L4
         SlCk5qOnP/fif2yptA7JQdGhItrc3Cmf4W3RRt4mJn/YRIeBysnihfUWhG/ETpbcsIMj
         8BRF0nCG/aQQeQLGg/IbAy1rJg3k+vMEM+BppRBKgMrUwBp2NRLv8JJDTADw6KvwaxIw
         L+a61V1U3Hw7ig9fsEkVIB5nvEEcgEAqXZVdT+hCKOylsHBXP+oQ8y5pbXKiQgYTKa8l
         pPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O9OQLWU+L8cw2kQ65uVTWLezhpLVOU7vvKIvyjvb5go=;
        b=I2Yu/SlJF5IQdB0AY0ByeYjFwCbom8px/bKnJzSn/ZirM8GOUw05moxqOysPiSCFZQ
         3b9tLeWmgIv4GQ5Z+AeXpLzkxxaStirCjJz5gJlETWtoRcOjD2lYB40dj2dXHLluZCqV
         MYlwcczG5ECzFKOHMYXRc83Sza6ViNYGneFGZGhkRQ8fTE7aQ5q8zh2KrV6QFIGHnnlW
         ks36cb272XQVLq9fqA68R33hBqjn32enRw4KffXD7L8nvcOYkvyhsn6o2BZLgTPYnGMf
         Nq2KUeOti+pIvgenrfPTjy+dFHCd7Da9SNwGb9XQpTk/5QD3pHvBfRf92eP/rH/yp2oc
         6UlA==
X-Gm-Message-State: AGi0PuY2pkRyQHsacoCA/by8aRCuV8d8QTpVxwUsJ5wWN9pUMKrCQmj7
        +/lmTpr6v6lv104u3FZfEROi6MV+14HTrawaVw2tNEtYEx4=
X-Google-Smtp-Source: APiQypKfCwrUsUM9Uh31ug7UZNa+TyfFlFUvLHZi2jIfMrQzrF28VySiHkHgZCyv/HNL5gz86//tJNxUHMVSEl4Jlag=
X-Received: by 2002:a9d:6a49:: with SMTP id h9mr6481301otn.189.1586377130037;
 Wed, 08 Apr 2020 13:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
 <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
 <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
 <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
 <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com> <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
In-Reply-To: <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Apr 2020 13:18:38 -0700
Message-ID: <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, V=C3=A1clav

Sorry for the delay.

The problem is actually more complicated than I thought, although it
needs more work, below is the first pile of patches I have for you to
test:

https://github.com/congwang/linux/commits/qdisc_reset

It is based on the latest net-next branch. Please let me know the result.

Meanwhile, I will continue to work on this and will provide you more
patches on top.

Thanks for testing!
