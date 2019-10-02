Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA59C9484
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfJBWy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:54:29 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35377 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfJBWy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:54:29 -0400
Received: by mail-lf1-f65.google.com with SMTP id w6so313790lfl.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LuKn0yMGsula0qz5RapziKUyAoMNwVeNzzbmW1Cw7/w=;
        b=Jr1ddmUWeweEVtyYQSVxWNJRuyceX3XpL0WKxYYCi0OUo1xyCpNUxqN7Ty2XGlgQoc
         3a9KUKVOPXV3edwTCEPUec9QYAXYgi+skMyfbZISDZ/qiAzl5PntzEHH73zgiTUWNKS7
         DY4aVUe1WTbtrpPD7kOyTCI4pQbLZJmn0R3pi8tRQNdU+UtCQS21G8rmgwokbNFkxiFV
         jptKdu/3SPS/SGkpyIcaHR/8eEkJDaFM9FvAt2oWhWvp+9BkZO6UzwabTO9ab4FORc8G
         /mbEadRucnqlzb/1whMLTfmVAuIyI6kbKl0MEnbrwmi+6Fv3lmBmuYBeofyJ5A/bOXJd
         c5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LuKn0yMGsula0qz5RapziKUyAoMNwVeNzzbmW1Cw7/w=;
        b=XoY5+oiOHKPDK3cns3X6oeoL6pQaPJ/5eIxjumj+66cVHTAHWF+JKfh5PRE2qcBMAH
         LuD8plqPNyHItmnnMbArs1tww0eHeAsKcKqq523CP2799tXilOx3HzxAXnZP5EjTre91
         MlyiEjhSo4PqAzbZQnZ6pIz5GxSSrjv/vugPZBPa3jygiXrar6ODxAYRR42XZNyTb7rM
         pxxITzwpgfrfMJuqSnu1RAa1ccNxJsk9JMdkvFMjV4iQl83RWZ3iQbFCFOTowO24KZSi
         f9T6bz8xjb5fcMX/n23MLlHnxvx6xleUyEUnMt/einXMH0Re07PBEkIg9iH8Reg+aP5J
         AbzQ==
X-Gm-Message-State: APjAAAXRv0J68qx60ZiNREyJn5E49GKJGKjblbZe5+y8K7Lwkk+94RLI
        q37iPkHJjWlZd6cTskYQKTkkW1hO6JLW2zyS/gk=
X-Google-Smtp-Source: APXvYqz00cNLER3uqJWVH+gjQRFCnaBSoKbz1fJTRd9Idz6TjTCg5Cl+IPd0lZChPbbfWrM05HFg1E2vef7AP9xzJCc=
X-Received: by 2002:ac2:515b:: with SMTP id q27mr3798328lfd.154.1570056866969;
 Wed, 02 Oct 2019 15:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191002221017.2085-1-wdauchy@gmail.com> <025bcf1e-b7d4-5fa2-ec68-074c62b9d63c@gmail.com>
In-Reply-To: <025bcf1e-b7d4-5fa2-ec68-074c62b9d63c@gmail.com>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Thu, 3 Oct 2019 00:54:15 +0200
Message-ID: <CAJ75kXZT1Mt_=dqG+YEZHpzDLUZaPK=Nep=S85t9V+cT1TNMfA@mail.gmail.com>
Subject: Re: [PATCH] tcp: add tsval and tsecr to TCP_INFO
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     NETDEV <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On Thu, Oct 3, 2019 at 12:33 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 10/2/19 3:10 PM, William Dauchy wrote:
> Reporting the last recorded values is really not good,
> a packet capture will give you all this information in a non
> racy way.

Thank you for your quick answer.
In my use case I use it on a http server where I tag my requests with
such informations coming from tcp, which later helps to diagnose some
issues and create some useful metrics to give me a general signal.
Does it still sound like an invalid use case?

Best regards,
-- 
William
