Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA9B22615A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGTNxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgGTNxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:53:04 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FABC061794;
        Mon, 20 Jul 2020 06:53:03 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n26so18155178ejx.0;
        Mon, 20 Jul 2020 06:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=91/9pndnTWqsVd/x5b/rm4BkG7ejpPeCX9bzux8jqKA=;
        b=G00denUDqg+DRYUuTYfU8AzJIpYwk2splRc5xVzRhR8STQ5CoAii5gsx3rM4EUOVXY
         n0gGj0SXXRHgr0Fzob8YxLLDiXuxLkkKmktseffhOpzNR4HllVq2/a6FUO8ohjb0RKDJ
         pH2ewwXax5sW7gxH97kwPMXwKSlZ6w/1P58qkJXw0xfx+WdpLV7T3/vAPqqnoNjO/AY2
         cVE3bEgpqOm9gZA13nEyOEHWaRNeuVEjIVd6ewfQnSlVLD7C/U7lOQNwVgNU090+wrBE
         U61MIJM+VC9wG/QCY08Ypi3oc/V1tNY/nkTZQ/hLXZ7dpAWbe422v2trQtKMELtsyRCX
         wRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=91/9pndnTWqsVd/x5b/rm4BkG7ejpPeCX9bzux8jqKA=;
        b=jOqNHGE03mwm8d6Cq/8L9vtblRk86JCvOosam4q1zbtBwy2iwXqOlZ/lRxunzafhhB
         2gA1XpbTXp+Zucu//UfjHTOg++45CyaQqeeV3hyTYt8ghWli4N57wBQQfVtwUewBuC+m
         Msax+End9TgVDWuOUy3BUFpShHJ4ld3fnGMkopY7gvdbm3rBlWOZLfyryKS/xAHS2FiF
         9+IVD+oTJh99Q9nyw98xahL9SOEoeuzTCXhZDfQfcYm/l0nuE3ApQ1iayrirZb4rRq41
         nTMUuDjG9s1Hlvj2HYNSCXOFk4Mtr0SjOhfHaxbGcTwpwbQnXpvex+02b0eJHxZGUKc8
         Az2w==
X-Gm-Message-State: AOAM531+aNBsxCAqtTMJwJWXIkQRXnBd3+3I6p6m2r3Sd+4POBACxOz4
        kfJGD4EkH5OAATHAM9CCXKbhhpTNTH1Co+uCKkU=
X-Google-Smtp-Source: ABdhPJwoJuDxjkJXZXvxYPhc3NtPiZeBFIrxdXl6ISg2Jz/jab+94GyEdmCIObnL/XQFQkVw2k6S3fPapncqW2uORZQ=
X-Received: by 2002:a17:906:2dd2:: with SMTP id h18mr20283149eji.504.1595253182568;
 Mon, 20 Jul 2020 06:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200718091732.8761-1-srirakr2@cisco.com> <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
 <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 20 Jul 2020 09:52:27 -0400
Message-ID: <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com>
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
To:     "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 12:27 AM Sriram Krishnan (srirakr2)
<srirakr2@cisco.com> wrote:
>
> +Stephen Hemminger
>
> Hi Willem,
> Thanks for looking into the code, I understand that this is more of a gen=
eric problem wherein many of the filtering functions assume the vlan tag to=
 be in the skb rather than in the packet. Hence we moved the fix from the d=
river to the common AF packet that our solution uses.
>
> I recall from the v1 of the patch you had mentioned other common areas wh=
ere this fix might be relevant (such as tap/tun), but I'm afraid I cant com=
prehensively test those patches out. Please let me know your thoughts

Please use plain text to respond. HTML replies do not reach the list.

Can you be more precise in which other code besides the hyper-v driver
is affected? Do you have an example?

This is a resubmit of the original patch. My previous
questions/concerns remain valid:

- if the function can now fail, all callers must be updated to detect
and handle that

- any solution should probably address all inputs into the tx path:
packet sockets, tuntap, virtio-net

- this only addresses packet sockets with ETH_P_ALL/ETH_P_NONE. Not
sockets that set ETH_P_8021Q

- which code in the transmit stack requires the tag to be in the skb,
and does this problem after this patch still persist for Q-in-Q?
