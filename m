Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9376E10A5BE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfKZVB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:01:57 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40348 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:01:57 -0500
Received: by mail-qt1-f194.google.com with SMTP id z22so2135679qto.7
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 13:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LZADdDCs8kZlypAqOQ+UywRu6jBdl/XzMhbP8T76rQo=;
        b=OJzfp2oHlVIv8mEwAhPnWqS9e5RCNcp4b720mzkr1WV7vz9+sVOod6C9UwOH8o4PNM
         cIZqWzS1zHQmoPc5rZJMsn7luXKHnZ4Iq/1TXA6sqJXtZAalJFzCS4KW6EMwq00NJsCj
         G8yLqZnk8+4dTm0VvMPIZPjLIPDsVo6ka80viLphsxfs1yroZ6swqpMM2Zirij5hOJUi
         pCPSBlkKRAuSHb9HHWZPSKGEuqR1kNuwm286ymepUkoGXodyRaLVoj4jrREafn02oKZ/
         00puqOt20LVxnciKyn10ujMkyE7aeALskG3Cx9lqAbh8fQDDybqkLJkWZlR5hLTRCMa4
         HYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LZADdDCs8kZlypAqOQ+UywRu6jBdl/XzMhbP8T76rQo=;
        b=T3+qWcZCnImRgfy/qwLCRE06j+mt+Nm2Dgs4zCBRvvidXyLqGNvYTgOlb0ISzvoHYk
         JytfVpC5gGdoctZ9cOH7kgEIajcpMofsXsARb9sdjwGO3Poa5mjdHdAv7rZBgda3MNhA
         8We4cULAHYG1crr6LKj+k9f/nBb5VN+e8dq5qIS1R+j7DfR1B6+eRD0NUOXqEBd6QFWL
         uNsjL8gYWc7gcPD2hhBUfe2RzTdKeXk/ufb9tLSfzvHEeOxqsjYjFtSZStAnHkY+wsK2
         L42QX7zfORYIiRa79ONFA45wKLVF4scrA3307CwwFOluuwZbRoDPHBU2mv5FW8kg9oq3
         eJug==
X-Gm-Message-State: APjAAAWHRpDoqA+gkDVzirqQuOgbYK9msBsegwdJMPD/8T4OXoB/koFS
        NeHZ6qgodWCjTNOOo70EY9KLiP8WSAo=
X-Google-Smtp-Source: APXvYqzS29aUw14+nhm5htBZLZQXcUq8pZwr9I+qtSUUadhXbniccUBL+MaKpxckBTyF3Ma6KO3SrQ==
X-Received: by 2002:ac8:27a2:: with SMTP id w31mr20427808qtw.227.1574802116127;
        Tue, 26 Nov 2019 13:01:56 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:3bac:6dc2:4a4b:b6a6:4365])
        by smtp.gmail.com with ESMTPSA id m22sm5615872qka.28.2019.11.26.13.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 13:01:55 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7D693C4AA5; Tue, 26 Nov 2019 18:01:52 -0300 (-03)
Date:   Tue, 26 Nov 2019 18:01:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net-sctp: replace some sock_net(sk) with just 'net'
Message-ID: <20191126210152.GA377782@localhost.localdomain>
References: <20191125.105022.2027962925589066709.davem@davemloft.net>
 <20191125230937.172098-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125230937.172098-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 03:09:37PM -0800, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> It already existed in part of the function, but move it
> to a higher level and use it consistently throughout.
> 
> Safe since sk is never written to.
> 
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

Please Cc linux-sctp@ on sctp patches.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
