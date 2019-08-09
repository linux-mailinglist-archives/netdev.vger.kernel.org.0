Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DB98821B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437389AbfHISPc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Aug 2019 14:15:32 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45015 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436676AbfHISPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:15:31 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so95815094edr.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=m8pPWHG5EFxx+J5X3MdEU52omI2AMpEXBWPWRzy6aPY=;
        b=bHabbR4NcO0P68XrK8cBPkIgBW9dkBD6DxiQc1ZdhOJezMvr6yBcyM3vh/ZpfqeeZY
         AR3eIZ3rA1zakftWj/WIFdr/0WQr2VYxHNK2Al3+FSmiQHLvtcdwEAoNfG/nILV13/+q
         ZX2IUR3/xDcR9tbfHP/uAzgqlEdGjUxqmuyhbOHojq8+/AHoeHCXFVT4dW482QBc+9GP
         HD8iRpCinOaBMjFpl8KR9K5RQJ9Lqzzz5doK7SB9keQtb6h3UlZJ6CxfIr68O78XBXX7
         bBwpKB0mkRpObtXETZ1RPs4cAm/cEnxjyyfQ1a4BBgdDMks98Vb/dDOokADvhOhbcT/9
         Pejw==
X-Gm-Message-State: APjAAAUz8bYaBq7uSAJpNcTMmSQ/JR/uKowj8KZGkjvd1uLxHHOW37l7
        113Lo3KWRo1UpbMkVuEkqoWAcw==
X-Google-Smtp-Source: APXvYqxwI2L++e34gz8OzPt3rY1wruUhg5EaqeOl9UdFImwqEMnffUnQJN/LwK2WkWJvhXYQQkQ0qQ==
X-Received: by 2002:a50:b7a7:: with SMTP id h36mr23414087ede.234.1565374530233;
        Fri, 09 Aug 2019 11:15:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k2sm15985266ejr.71.2019.08.09.11.15.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 11:15:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3485E180BF7; Fri,  9 Aug 2019 20:15:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190809125418.GB2931@splinter>
References: <20190807103059.15270-1-idosch@idosch.org> <87o90yrar8.fsf@toke.dk> <20190809125418.GB2931@splinter>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Aug 2019 20:15:29 +0200
Message-ID: <87d0heqk72.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> On Fri, Aug 09, 2019 at 10:41:47AM +0200, Toke Høiland-Jørgensen wrote:
>> This is great. Are you planning to add the XDP integration as well? :)
>
> Thanks, Toke. From one of your previous replies I got the impression
> that another hook needs to be added in order to catch 'XDP_DROP' as it
> is not covered by the 'xdp_exception' tracepoint which only covers
> 'XDP_ABORTED'. If you can take care of that, I can look into the
> integration with drop monitor.
>
> I kept the XDP case in mind while working on the hardware originated
> drops and I think that extending drop monitor for this use case should
> be relatively straightforward. I will Cc you on the patchset that adds
> monitoring of hardware drops and comment with how I think XDP
> integration should look like.

SGTM, thanks!

-Toke
