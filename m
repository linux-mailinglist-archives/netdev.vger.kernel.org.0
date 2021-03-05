Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4132E6A5
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 11:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCEKq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 05:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCEKqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 05:46:04 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1658EC061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 02:46:04 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 7so1574153wrz.0
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 02:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TB/rJeJ9kSqCs8q6Neg8DOEblWFqwOdLl0PMsbhFMgM=;
        b=DMD6BlkztjC58vYQfIIQ8KTx1j3h9mjUwPtGl8t9nB6Om8LFVVhObIgiX1VgxkvJSI
         NBQssMD+q8I5dSQx0eN5svzSKJuz16KflxKJQqfjLjmuxoA4TUU63XQ26GoPB2jcW5uQ
         kt6vNDQYCTNwGcL3j+29hrR7xGadnaB7Fxbrjvg7cOJluXvjnPtl9F7EHucuxaqpVlKl
         SYwv4vPC2LE6asjFs+/tasR/hIaXIrSMAv9mkqEXJrHuxpPf6OkP/rmc591I+VtsIYQ1
         W036TboDkw2ufVmF/A32cS3rmGzb1lXazWZyRNVuQUPeibsTx4INg9EdOCCYTVhGS5KK
         wnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TB/rJeJ9kSqCs8q6Neg8DOEblWFqwOdLl0PMsbhFMgM=;
        b=AmAo9Tv5jlx+oLYo6dKsISwRISsw+eh0c99eNVK5sPGS3zFoaivGY+YILMW0SN5N1I
         hdy37lzwWeO4cUnjiApSqz2FOdOLrgyVBaMyIUvLKtrvbOahIcB9uuoqxY4ly7E9gE0i
         Yf+LEDzXxN50+DEO+uz3jBh3gDGPWwF/wIVW1dKr4o+/tBjfLEoTAgcZbonl8JrJwiHI
         M+Eff26tWJc0bR/YPx73oSzLuOBL1meZ3VFIX8S9zLWJ0/TyjwY3XD9yLUD0ULmvCFZ3
         wUIyUX461gC9yXvI0xP5SSgnO5XnqhEidHhxkCI5/+YyfjY08TixKbVoGK37k3B3T2zU
         7GQw==
X-Gm-Message-State: AOAM532dGdUDxI4Dc4ihppKENM9Z1CyWGhswSJ+KGrI4hdp47WxU+Iiz
        5trLUCN9qCn/SFV3YU7rbWgF3wK7PRGotAlUnw2UXT3lUfYUPQ==
X-Google-Smtp-Source: ABdhPJzf/SXSpjNZWKBVImKl+hqDT1p6bQqnO05VqMwTS7EyN33wUoBFUXyh3DjV2jcWKWff1I7a239RNf1jTUz1bSY=
X-Received: by 2002:adf:f2c3:: with SMTP id d3mr8770745wrp.380.1614941162748;
 Fri, 05 Mar 2021 02:46:02 -0800 (PST)
MIME-Version: 1.0
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 5 Mar 2021 16:15:51 +0530
Message-ID: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
Subject: Query on new ethtool RSS hashing options
To:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a requirement where in we want RSS hashing to be done on packet fields
which are not currently supported by the ethtool.

Current options:
ehtool -n <dev> rx-flow-hash
tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r

Specifically our requirement is to calculate hash with DSA tag (which
is inserted by switch) plus the TCP/UDP 4-tuple as input.

Is it okay to add such options to the ethtool ?
or will it be better to add a generic option to take pkt data offset
and number of bytes ?

Something like
ethtool -n <dev> rx-flow-hash tcp4 sdfn off <offset in the pkt> num
<number of bytes/bits>

Any comments, please.

Thanks,
Sunil.
