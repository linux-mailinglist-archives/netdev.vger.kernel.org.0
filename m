Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0B337CC
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFCS0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:26:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44936 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFCS0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:26:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id n2so8744403pgp.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=4k7GRXlyfxsLxv0xefE/UVRhHlrS8tnLjxoE+uikhqA=;
        b=oyYL7ar+UzLKxFjX3zxaKvu8PIl4t73wueYt64ond6gChuCw2cH7euWYZNkPjATGOH
         xTcZFwTcCr3ZhbBwYTPvrn5+y+7VgNFFINphebnPT4Vsb6JvbVKyTpeasgPE1ReMOUwB
         zViM16RWi8VXDLjEE8FZngbYIG7LNZymny/gbDmkq24EutSD5BZKfNpfjaIqOAdldd4Q
         P0FsmxdOCc6kBHYxV0YX56SldPBpVfok31i6WQxPsWOMd6Q9LYmdyqAKY7UhgseypIjV
         XwuFmEuuJETjncemnaZxPAFA2P/ebkbPKmUzi1+3P3jlhJP2wvBMqKXsu3h1WlY3b+Hz
         R+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=4k7GRXlyfxsLxv0xefE/UVRhHlrS8tnLjxoE+uikhqA=;
        b=VEWNplfx7JI/PdZCT9mbClk73o/HZ/vVBCbC5YKkFvSipD7BVnbqfKbTF0ruYtmIHs
         DzBFdNkzOfLkm5YBZuR2qeZWG7Pj7pM4L+46XeTuLC9+qMTzYRsvx0DA7PVZk2Wm/CrR
         tlkp5itoxC6OcWXlCygBArSaysLbx94MJuJKeO9UoBgbe8Dx5UNwftV+0dHwdRSSTL/B
         GmlfGrmS4kIjbNtE5RXUeA+ccQhKwHWkt7Jur9psWE50oM1hHVuqDveCPcoxjHrx3jLh
         T1b45rCa/d3iU6pNv5uj1GNsdQ3pWlpAAlGf922jxTvljWWt+ZlFaOvGesFtXhRbs0zm
         xF5w==
X-Gm-Message-State: APjAAAW+SkU18GR5fXflI+MfE3a9y9Aw7BqsDf2dQ0F4nNMmEnZjAuKS
        qP37rKgBDHIxRCskb5wxdlE=
X-Google-Smtp-Source: APXvYqyQILvIjkQ5y/4e9ZnPj1Bzk/nMLurInMv2WGl/Y6NamhkeDUXD6jJWGKqZTwZxpkJS0fBOXA==
X-Received: by 2002:a62:bd0e:: with SMTP id a14mr33153261pff.44.1559586363580;
        Mon, 03 Jun 2019 11:26:03 -0700 (PDT)
Received: from [172.20.92.49] ([2620:10d:c090:180::96c4])
        by smtp.gmail.com with ESMTPSA id g17sm25295204pfk.55.2019.06.03.11.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:26:02 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Maciej Fijalkowski" <maciejromanfijalkowski@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, songliubraving@fb.com
Subject: Re: [RFC PATCH bpf-next 4/4] libbpf: don't remove eBPF resources when
 other xsks are present
Date:   Mon, 03 Jun 2019 11:26:01 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <D5F7F7EF-5B29-482E-BB6F-52A701A005B3@gmail.com>
In-Reply-To: <20190603131907.13395-5-maciej.fijalkowski@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-5-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3 Jun 2019, at 6:19, Maciej Fijalkowski wrote:

> In case where multiple xsk sockets are attached to a single interface
> and one of them gets detached, the eBPF maps and program are removed.
> This should not happen as the rest of xsksocks are still using these
> resources.

I'm not seeing that behavior - each xsk holds it's own reference to
xsks_maps, so when the map descriptor is closed, it doesn't necessarily
delete the map.

There's no refcount on the bpf program though; so the socket should not
be trying to remove the program - that should be done by the application.
-- 
Jonathan
