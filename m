Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00D64DEE
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfGJVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:12:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44637 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfGJVM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:12:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so3501686ljc.11
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 14:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwvajVWMIb62q8wACGYhWs29kEXd/GDO5w+T3eFYJVQ=;
        b=ix9E8oHqVOHHI7+NbnlUqfsJnN4HBLwyr0Jn9m3Tpk6LEOunHnYze3vGWP8/aAN+JQ
         o8Xb6a4lS1X88VxaIJw7qDyL2rtrdl8yPiVKxFJVDlBDzUn/5GBcvnogmRiipUUSaZ2A
         y62oVYOH++N07WuupIrdvk0x7owfObLe29Q5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwvajVWMIb62q8wACGYhWs29kEXd/GDO5w+T3eFYJVQ=;
        b=nyfGYp85TOq1byyDBhATEv1JiyGvmlMxppCksFeuJaB59aS7DlO9dFvurBMhf2AkTX
         rarZpxGXp84cS7BEOW6075kHNZJrS2KqUVzgNV5Qa0/EaSQsS84GRHMpf0Jkeok0xkRK
         tN6qCYOKuv29Bhd5WpXh+Ajfok1IWQ2fkSM9urVXowMv51fxlrDre6np+M3XqmJ37CYy
         4NHoZlTprYtqGwphlbMxflybrL7brTcBOWxjdn1yHTmVTUub491CAesHlAhYyId49Q5H
         eSd52XDrfb9OIPYDu+ta4PLObjPFC/LsdHkIVSOw7ZwE0u63+hHYBtfreaub3YdJw6PV
         z3fQ==
X-Gm-Message-State: APjAAAVdvHnMBhsnQDp+RAj4U6lpSsKJzR6kZRA73lAij1qBtP9sbOR6
        Ph5bwNMwzNT/zOWIxfzmZlOaXqrfuas=
X-Google-Smtp-Source: APXvYqz4AKBmoNnzeVYHLjX+vVPNmndNkQqHZF72VOrkTjBVwX9JVQN9sSR2X+Bx3Cw7G6PWXLjdZw==
X-Received: by 2002:a2e:9610:: with SMTP id v16mr147750ljh.229.1562793147915;
        Wed, 10 Jul 2019 14:12:27 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id p5sm646246ljb.91.2019.07.10.14.12.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 14:12:26 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id v85so2563911lfa.6
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 14:12:25 -0700 (PDT)
X-Received: by 2002:a19:6519:: with SMTP id z25mr6190697lfb.42.1562793144979;
 Wed, 10 Jul 2019 14:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190627003616.20767-1-sashal@kernel.org> <20190627003616.20767-14-sashal@kernel.org>
 <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com> <20190710145112.GX10104@sasha-vm>
In-Reply-To: <20190710145112.GX10104@sasha-vm>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 10 Jul 2019 14:12:12 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPseNZkud1vu9zaRH-vA0rJq8D_t6pFG1LTPQtdr8_eVA@mail.gmail.com>
Message-ID: <CA+ASDXPseNZkud1vu9zaRH-vA0rJq8D_t6pFG1LTPQtdr8_eVA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 14/60] mwifiex: Abort at too short BSS
 descriptor element
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 7:51 AM Sasha Levin <sashal@kernel.org> wrote:
> I see that 63d7ef36103d didn't make it into 5.2, so I'll just drop this
> for now.

Yeah, I think it's stuck at net/master. Presumably it'll get into
5.3-rc somewhere.

Brian
