Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3D5C0B7
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfGAPyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:54:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35779 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfGAPyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:54:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so60391wml.0;
        Mon, 01 Jul 2019 08:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cq95xuiLFEI6emBiYsdvZFxr6etn0mSivEmoTJ+NQJk=;
        b=BiODAHp71E+SotRxGHOr5DAPDjAoGa9QWNP4Q2GsuwO1lnS5O80EEQkgp5J+MPi8M4
         OWHEAkIRNhKgBFrtNySWGU2p/0pjj1vDrK6gL3obdjIC/2UjKsYbKMDvU2DEYdXtkI7R
         2HoSF8QqpqG09Z0JuJWDLFFYeF4Xge8RUPqty1e0cWNa7s2X92GnAioenNZeJB9SKzqz
         UPXGk4nLUGUKlNLr7VHdChrtWmHIQNT4ZI0mMAeXtAnDgQ8h6vp79H09xeNHeIaPlO7W
         1R3KvlWgcefDnvajtXbIqPLzJ54qWpKYIDqJPEg1mdVVaivrtot6iGIbhG83bLhcgZRr
         pCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cq95xuiLFEI6emBiYsdvZFxr6etn0mSivEmoTJ+NQJk=;
        b=KaKUxsKAj3O+dd30UdWly5X8/CfbmhwjEP+Yn5oTfUCLXrMW3DeXXjO0qKuq+dY90F
         IcGR3lm1H/R+Jhy5uDHO1TE8o7dLozxyXYyTxhtN0rpRU9Im+cfwdk/iy0p9rPLNo7Yl
         8y2wvSm4NqQ8CVtAA3E2TrOvvz1bCkwnWqgvwkubBx4gHvUvy71QnE4qfbV+FIjbUGOc
         kHnn0h0vBdiLvQ1qe+chbU89tEZPFN8uQjkX4q7Fbl3wb30RnXhXH77FjAJGQfO2/zJX
         +KYwqdd1AZPyfHFIkRL60rlJhspJFCvvAUlZ+VbKWUaoIRpXiCkQZT/oo5Opgvvo0Bi8
         hrig==
X-Gm-Message-State: APjAAAX9H+iKWcRY/qPouYmQNhrjT06TQGtMeSSBDJ1LJ+V3lPCfXoxV
        rO2kDhhJwW97qi+nnKR9pas=
X-Google-Smtp-Source: APXvYqzfJfsS+mdflzd9Nr/1xNS8r3PTEzjpII3Hj4cFfXNUZXPVF20GH8n+kjJKjIO1CPCfqcC3HA==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr6872wmi.78.1561996488498;
        Mon, 01 Jul 2019 08:54:48 -0700 (PDT)
Received: from [192.168.8.147] (27.196.23.93.rev.sfr.net. [93.23.196.27])
        by smtp.gmail.com with ESMTPSA id z6sm9886992wrw.2.2019.07.01.08.54.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 08:54:47 -0700 (PDT)
Subject: Re: [PATCH net-next 8/8] net: mscc: PTP Hardware Clock (PHC) support
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-9-antoine.tenart@bootlin.com>
 <CA+FuTSecj3FYGd5xnybgNFH7ndceLu9Orsa9O4RFp0U5bpNy7w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <028ded20-61d1-4ac4-46fd-4a97faeac56a@gmail.com>
Date:   Mon, 1 Jul 2019 17:54:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSecj3FYGd5xnybgNFH7ndceLu9Orsa9O4RFp0U5bpNy7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/19 8:12 AM, Willem de Bruijn wrote:
> On Mon, Jul 1, 2019 at 6:05 AM Antoine Tenart
> <antoine.tenart@bootlin.com> wrote:
>>
>> This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
>> switch for both PTP 1-step and 2-step modes.
>>
>> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> 
>>  void ocelot_deinit(struct ocelot *ocelot)
>>  {
>> +       struct ocelot_port *port;
>> +       struct ocelot_skb *entry;
>> +       struct list_head *pos;
>> +       int i;
>> +
>>         destroy_workqueue(ocelot->stats_queue);
>>         mutex_destroy(&ocelot->stats_lock);
>>         ocelot_ace_deinit();
>> +
>> +       for (i = 0; i < ocelot->num_phys_ports; i++) {
>> +               port = ocelot->ports[i];
>> +
>> +               list_for_each(pos, &port->skbs) {
>> +                       entry = list_entry(pos, struct ocelot_skb, head);
>> +
>> +                       list_del(pos);
> 
> list_for_each_safe

Also entry->skb seems to be leaked ?

dev_kfree_skb_any(entry->skb) seems to be needed


> 
>> +                       kfree(entry);

