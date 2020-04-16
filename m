Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DC51AC63A
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393809AbgDPOgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:36:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393818AbgDPOQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587046600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=snN09EqG6XHvnzezdN+cva8glR16jRDPhcP7NveBwxE=;
        b=fAOwCM8NnqMLryo0q3Eh3Va9RHbzIXlDrcVjWghHDpGKMI7NeR9+HoqOiX4PLoHFi6o/5U
        JN+8MfH071AMr2wwFTni/zGBYE3fXv1w0pNaxKX/LZXrRH47ZymM+LfpQ+EkMJutassUBj
        AgY+jYv5bgg5sOT/f1ZPjC7SJZMh37Q=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-F7bwJ7GkMZOA-2t54IoYug-1; Thu, 16 Apr 2020 10:16:32 -0400
X-MC-Unique: F7bwJ7GkMZOA-2t54IoYug-1
Received: by mail-lj1-f199.google.com with SMTP id p17so1657110ljn.12
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=snN09EqG6XHvnzezdN+cva8glR16jRDPhcP7NveBwxE=;
        b=blZA5SlupYximJdJKo5MGeKLQSNrReLgx4PUbmixbKIJIGfh5J/xxVgDNwxjPsp2cL
         d3Ghh0DImeQtr+Z36NMa+2zo6nI9oH0BLIQvgLU2mAV2qlZY7HZKjKWKjXGadrgu5MRV
         4ghTW7vIZ1Kwmnj4BqwU+g850oVcwR2Kc2jF95VNHB5TfQAhQICzKa5vFCFm1KH6IJvK
         QN1nx0gDSmLGzwUmmVyD2Hoo2thPuYoYoYQaiEbpXBGGiN8LVKcOa5f7wN1xLztgvRGJ
         VIgP8vk806iZLvU+WxVaEeYnci1fYGDsl4zYmn8y6z9cmfXx/KBzMP6Y3HmyI9RFPenq
         +uQw==
X-Gm-Message-State: AGi0PubwvNWEWAaTBW78l4DzRqCO6yXPwn4V2+CLG2K+U0wC3OmDABvO
        CF7dbArIk0uykRrtDTqD/W+F+fsOjZ7nI6FHFrR0n5bTB5vJmw+4CTvjtRw4Po60YomC02BYumC
        /52hGz0R+CdTrDQOd
X-Received: by 2002:a2e:2a85:: with SMTP id q127mr6529235ljq.273.1587046590472;
        Thu, 16 Apr 2020 07:16:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypLJzFGHM0jFdH1ibojPAOYUIaXbB2X07I19/rJzgX0wF8tHepwj4QShMqKi5b5wwUvA1iuRRw==
X-Received: by 2002:a2e:2a85:: with SMTP id q127mr6529222ljq.273.1587046590296;
        Thu, 16 Apr 2020 07:16:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a3sm13843625ljm.100.2020.04.16.07.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 07:16:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 12955181587; Thu, 16 Apr 2020 16:16:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Odin Ugedal <odin@ugedal.com>, odin@ugedal.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] tc_util: detect overflow in get_size
In-Reply-To: <20200416140814.171242-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com> <20200416140814.171242-1-odin@ugedal.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 16:16:29 +0200
Message-ID: <87ftd3ldmq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Odin Ugedal <odin@ugedal.com> writes:

> This detects overflow during parsing of value using get_size:
>
> eg. running:
>
> $ tc qdisc add dev lo root cake memlimit 11gb
>
> currently gives a memlimit of "3072Mb", while with this patch it errors
> with 'illegal value for "memlimit": "11gb"', since memlinit is an
> unsigned integer.
>
> Signed-off-by: Odin Ugedal <odin@ugedal.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

