Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B588F5B80
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfKHW7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:59:45 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40853 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHW7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:59:45 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so4818319plt.7;
        Fri, 08 Nov 2019 14:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=oq5+/mMB3/ibfTyaw49I9b35P1TN/zsnD1/cmjpKrs4=;
        b=Io2g4gDlnEb3IbGp8gbIjK+xNsxYo8sHm9qYBzO6SULVBMx0weAlSrSxo0Cx+bek/J
         Kv+bmZpRX+B/mbmnwHH48wfoyA9c/foKvL+72PWrONQy6iOD//ScHEbo7+Z1IbtjMdGx
         ipzKX1MqkNLXsU2D/T68WXHctf+iu0BQHGt+S61Fv4FOvqFBvjatLTcg4EW4ND4DzqP9
         MFdit2oOdbZbEIOXTnTumT5WWPVUDWs9yf0DUNxgAWAlvZ2ljQpA6yEI7Pgp2MgKK/4z
         HG1bV73EkZd9Mp5xGCa5rVjFRpszEl5QCa4Lc98poOuNftEVinrQCSEa4Z9BZ+zRDvO/
         M3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=oq5+/mMB3/ibfTyaw49I9b35P1TN/zsnD1/cmjpKrs4=;
        b=ub8Fak7vAV5dtuWX7NMv+DEbSlz+1Ce5qPPPjode8wcRs6KeeA/acnl1sX6Bq0UiTD
         CBxzQPKb5Lt0MvP2ydoMU5Q7GdwsQYMnt9xy8jefRnruLLNpNRwOEHfNZQvL+fa4oQGv
         mXH81SHtmgXCYtfUy6o30RPmrAhFnS6ojAx554jN+wBMEv/sTRdbYwqD/t79kea1UIDO
         M1eQESJ7u0X+Kjas2OLT+zbOuCeIxa4YJzQFzKK9fgcgWGOoGNWUTjq0B0PQFo+MgU7f
         uvPD9OKdKIKe9VpEhtYzi5BZiRkYwnhvLlcGmaySSCTNp6NBj1CLnqaPc9n2XbLbyvoR
         iYnQ==
X-Gm-Message-State: APjAAAXPda4xlAxHo6+AT+iqGU3gWAfyTJL6nFlmojFPHnD/ZmHB4IKI
        1XejByQtgZLk4RkC1qCWH1I=
X-Google-Smtp-Source: APXvYqxKFA0SB32dE848lGAWewx14YWY/wuKcIZKcU4oo/RYiWb32wGA7vmBYLadIDpaAPSC2mxO7Q==
X-Received: by 2002:a17:902:758a:: with SMTP id j10mr13812251pll.29.1573253984494;
        Fri, 08 Nov 2019 14:59:44 -0800 (PST)
Received: from [172.20.40.253] ([2620:10d:c090:200::3:c214])
        by smtp.gmail.com with ESMTPSA id f5sm5453729pjq.24.2019.11.08.14.59.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 14:59:43 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, u9012063@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/5] samples/bpf: add XDP_SHARED_UMEM support to
 xdpsock
Date:   Fri, 08 Nov 2019 14:59:42 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <BCCF2352-9793-4546-8353-A8F926F4E02F@gmail.com>
In-Reply-To: <1573148860-30254-3-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-3-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:

> Add support for the XDP_SHARED_UMEM mode to the xdpsock sample
> application. As libbpf does not have a built in XDP program for this
> mode, we use an explicitly loaded XDP program. This also serves as an
> example on how to write your own XDP program that can route to an
> AF_XDP socket.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
