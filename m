Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EA1101281
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfKSEfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:35:07 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40013 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKSEfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 23:35:07 -0500
Received: by mail-pg1-f194.google.com with SMTP id e17so3347397pgd.7;
        Mon, 18 Nov 2019 20:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1vAR9pr+zCDnA9c+fs7AWDCb/oWZcql0gVEAoledK6A=;
        b=TiCzTjPTkxrZPTYjY++q7K5XMuc42Z2m3ZDTIE43dLkg9kuH9j/VL7P0TAun2ePnRh
         aBiorpb7jbAqdIUQSPK1iS96wciwlNfqe7m7I2txRBUKTzD8ewXzlUc5e06WRQ5SkK+1
         OQkiokjRiwYkepuDH6lr27tAhTAt04ohgT3vvC269qk+hWY4+QvV9pKW8ZTRtnpMfaWl
         V3UFE2EWLFw2ZzDkNwu6MJd0bQvodnKE5st5Mnu68O8dehgnxjS8VmvNkpu46IaW/7KN
         6MqhgG/fFd93/rBltodUFeWTwbXN6HXRuxB+dPDEx2sjUGgc3Uxf5CIasDdO4WaYqiPE
         zbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1vAR9pr+zCDnA9c+fs7AWDCb/oWZcql0gVEAoledK6A=;
        b=nwXITuR6400N/BH/9wEFriaQKiRqPdMRu/y9aJf27vR/aqKNuhGaT3CAKXE/vaeOKy
         znyC2xbwlQkYMTDyMtS05jdID/OvD3EL06GvozdM31K0IoE25M4tA87qXVuexXveXLE+
         stk0khQuQq95TadeP8mwj/CuaYXwRmDBzKiVG30YRtlicG0X5K2wdhhmyL9enG9gyELJ
         y2lEpN5rRzrvgpYgK9aJqPsZALEt6JocSPd4YuQJ8606xnJdaIWuy3Yky0CMJYHwDToa
         aewG5sV2iZqWTdUBf6zy5BUrSYZyhOYp7VjXSxkub7qC7W96tzzi/f+eLI9t4tv63Bbw
         meCQ==
X-Gm-Message-State: APjAAAU72WWBWQZrHBbvrWHghF5AoJLBSmFc18gmiHZ2eFIy3DhzMPRh
        j/Xy0lw5Yg32fXPI6DDrUZk=
X-Google-Smtp-Source: APXvYqw2upkCNdRdCwE1MLHAT3ARTAwvLwXyTicefk9hMVi7ATCVZaU13dcZHDyfp+cVK7uiCyHYJw==
X-Received: by 2002:a63:115c:: with SMTP id 28mr3287445pgr.6.1574138106592;
        Mon, 18 Nov 2019 20:35:06 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::db2d])
        by smtp.gmail.com with ESMTPSA id y26sm24526869pfo.76.2019.11.18.20.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 20:35:05 -0800 (PST)
Date:   Mon, 18 Nov 2019 20:35:01 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 5/9] bpf: add batch ops to all htab bpf map
Message-ID: <20191119042012.3wpj5porwkntpfm4@ast-mbp.dhcp.thefacebook.com>
References: <20191119014357.98465-1-brianvv@google.com>
 <20191119014357.98465-6-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119014357.98465-6-brianvv@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 05:43:53PM -0800, Brian Vazquez wrote:
> From: Yonghong Song <yhs@fb.com>
> 
> htab can't use generic batch support due some problematic behaviours
> inherent to the datastructre, i.e. while iterating the bpf map  a
> concurrent program might delete the next entry that batch was about to
> use, in this case there's no easy solution to retrieve the next entry
> and the issua has been discussed multiple times (see [1] and [2]).
> The only way hmap can be traversed without the problem previously
> exposed is by making sure that the map is traversing entire buckets.
> This commit implements those strict requirements for hmap, the
> implementation follows the same interaction that generic support with
> some exceptions:
> 
>  - If keys/values buffer are not big enough to traverse a bucket,
>    ENOSPC will be returned.
>  - out_batch contains the value of the next bucket in the iteration, not
>  the next key, but this is transparent for the user since the user
>  should never use out_batch for other than bpf batch syscalls.
> 
> Note that only lookup and lookup_and_delete batch ops require the hmap
> specific implementation and update/delete batch ops can be the generic
> ones.
> 
> [1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> [2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> 
> Co-authored-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

SOB order is not quite correct.
If the patch was mainly developed by Yonghong it should have his 'From:'
then his SOB and then your SOB.
You can drop Co-authored-by field.

Patch 2 was also mainly done by Yonghong or not ?
If so it should have his 'From:' field.

