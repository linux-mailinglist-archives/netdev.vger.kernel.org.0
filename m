Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AD31ABC0C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502922AbgDPJCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:02:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502790AbgDPIsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587026888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h55+1NFubEowJcMzdahYTyZcdFK80pFu/8HHK8y24No=;
        b=F8vBjtvLyHJ0bN6CzsxODQk9aK+vRx7juGw5V+T1/Sn3NqQxTMdowKQf0/0X/TJ10GDDPu
        fNtIo3VEkvLbDhbB5UYE8TbNIxP2F5xlwiwgs7vpMHL25inyoL6XUxCnKtAXikMRY3g7N5
        z+7IcnUqwWinwp55RdopNxSKrAUmnI8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-Agqf9QsiPuqgATytTkUNcw-1; Thu, 16 Apr 2020 04:48:06 -0400
X-MC-Unique: Agqf9QsiPuqgATytTkUNcw-1
Received: by mail-lf1-f69.google.com with SMTP id h12so2165381lfk.22
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=h55+1NFubEowJcMzdahYTyZcdFK80pFu/8HHK8y24No=;
        b=BSgL6bMVdUQW2+EMUvgcyyQavqEPNc8BR4aDpioTBHiMcdcG6gK4TlM3vVqU++JEu/
         eY2reyiLAj1sOMiJidlCLBdRW4Bwz3dOfRJWBSEE1dmd8GMCZOFENk8BG9wn+KWqJsnT
         mQktpsgp3AsI0XjTnWtat6wGUFMlUPg6r1rjGl6aEemIBpptGETemwNyLT66cd+LeABd
         fwRjbpI4+dCWESVEgvg1Od44ttp9UjgdDCEx5gD5B5vcbFGm3x8X/7O7fq/4LOiYPsvu
         RWW2MX6y3Y12QXugdPZcPBuaU+MimHXnrqnx34C/I3ouTnwMbKDFKGl1Y28trqEhxHds
         2fCA==
X-Gm-Message-State: AGi0PuZhuL57ATiBlSV3hkURRbg2JH+BoZPAfo9+n+4/vQsEVXDvcYtU
        ST7oVj7XQTnmdaIxy8H0DpNCoTZnO0b3BgHFbQVevM876qbFKnZfqwQaasi/SY7/tnb6lJpWMGp
        plTcp9wfiTb1Fn+l4
X-Received: by 2002:a2e:992:: with SMTP id 140mr5776203ljj.188.1587026884681;
        Thu, 16 Apr 2020 01:48:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypK5cz9Hb8Z4nniRqUt7Rh8EsBHhOXUVaXVq/pDpiuuBw78BJhOJexX1QiYNeCqGUeRtBCIJ+w==
X-Received: by 2002:a2e:992:: with SMTP id 140mr5776195ljj.188.1587026884520;
        Thu, 16 Apr 2020 01:48:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w24sm13383657ljh.57.2020.04.16.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:48:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 400A8181586; Thu, 16 Apr 2020 10:47:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Odin Ugedal <odin@ugedal.com>, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: Re: [PATCH 2/3] q_cake: properly print memlimit
In-Reply-To: <20200415143936.18924-3-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com> <20200415143936.18924-3-odin@ugedal.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 10:47:59 +0200
Message-ID: <87a73bn7eo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Odin Ugedal <odin@ugedal.com> writes:

> Load memlimit so that it will be printed if it isn't set to zero.
>
> Also add a space to properly print it.
>
> Signed-off-by: Odin Ugedal <odin@ugedal.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

