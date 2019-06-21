Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0834EA05
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfFUN5x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jun 2019 09:57:53 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:40803 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 09:57:53 -0400
Received: by mail-ed1-f50.google.com with SMTP id k8so10260553eds.7
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 06:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Vv3Wcv1F8z72B8BAiMnHckjaR7xCiJ8P8UB0AlZQiLY=;
        b=edHrb9iNmlt5Y0YBCPcIafZtMBO0pBlMTx4rVLXt7wl1fBuL8usTzvMpmi4s8ewBiz
         lXGJy2xIuveBEGcdn7LZqLVByUtd+JUARh60hv/cL2ZHkCF54l0jrxK/8ruecL4wL9J9
         eyMj1DzsAraOrz1IHnISiEN/Q2h/Myjtk6Ay2X1zBdtIFZBewf7cq/Ris1d3gyWA1Jwe
         G/JFgSez4hVIPZqwVRDoBOGqmtFLlge5llqCpeQF4fDfNUtMdF8nHNhnLJlqQzfm8oMr
         qKxwI5RIpobL9uaX5Xsz5Y8DC297iUcHEbT6aphMhCrW6UeDuWc/JvESnESg/75VE+Ad
         2cNg==
X-Gm-Message-State: APjAAAXlF+eCsxLqDeyZ8+IfhKH8FVNwGmLe3k9sXG9Aq/oST3dEFKVY
        0/erAIm2et75MCjOdM4umhsjbw==
X-Google-Smtp-Source: APXvYqyDhvTDMLZyahHsOHOgpsHCpfII7U3/p7JTI+IDY5mLNcGC6WwwHLjUA/podhWODKZsrVDCOA==
X-Received: by 2002:a50:bdc2:: with SMTP id z2mr16007456edh.245.1561125471587;
        Fri, 21 Jun 2019 06:57:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y3sm839335edr.27.2019.06.21.06.57.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 06:57:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F33F81804B4; Fri, 21 Jun 2019 09:57:48 -0400 (EDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, mst@redhat.com,
        makita.toshiaki@lab.ntt.co.jp, jasowang@redhat.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: Stats for XDP actions
In-Reply-To: <cd9136ff-4127-72a5-0857-2e5641ba5252@gmail.com>
References: <1548934830-2389-1-git-send-email-makita.toshiaki@lab.ntt.co.jp> <20190131101516-mutt-send-email-mst@kernel.org> <20190131.094523.2248120325911339180.davem@davemloft.net> <20190131211555.3b15c81f@carbon> <b8c97120-851f-450f-dc71-59350236329e@gmail.com> <20190204125307.08492005@redhat.com> <bdcfedd6-465d-4485-e268-25c4ce6b9fcf@gmail.com> <87tvevpf0y.fsf@toke.dk> <44ae964a-d3dd-6b7f-4bcc-21e07525bf41@gmail.com> <87sgs46la6.fsf@toke.dk> <cd9136ff-4127-72a5-0857-2e5641ba5252@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 21 Jun 2019 09:57:48 -0400
Message-ID: <87k1df6nxf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 6/20/19 2:42 PM, Toke Høiland-Jørgensen wrote:
>>>> I don't recall seeing any follow-up on this. Did you have a chance to
>>>> formulate your ideas? :)
>>>>
>>>
>>> Not yet. Almost done with the nexthop changes. Once that is out of the
>>> way I can come back to this.
>> 
>> Ping? :)
>> 
>
> Definitely back to this after the July 4th holiday.

Awesome! I'll wait until then before bugging you again... ;)

-Toke
