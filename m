Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E9513840C
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgAKXic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:38:32 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46380 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbgAKXib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:38:31 -0500
Received: by mail-oi1-f194.google.com with SMTP id 13so5133123oij.13;
        Sat, 11 Jan 2020 15:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c7HFrOGQ3phE12eoMeyUfOtwv87GN61OlvlGebweSPE=;
        b=CUzzXi3uv6xXm/4UnggMbWvrrN2Up+aCdXgbjG6cA1RSh2Hsl7MaJGyUzdoMoTmd4R
         ZrHmzvSIQzS9GFymrJPYSFUJoVbzF0PJ/iecYAh4HGcrfH/zwmd4F6x9nsoOeailYobC
         MujffRFXqGvkpsurYLOjgR9qmZoZeeEk+kwuIIysdTEHyy0eM0MPpC10Mh0InyVmHn1v
         5FsP+pOKLqj3MpjEbbWZWOZEilHIuIlxKrmee02exZm69I3xF9XolTxJTNhKMd4CPNUr
         7TK8yRsQode2rHqJa9VpU78VxSiyf+Oi7TyRFsjn5WlXmrtjazYZe5Wjb+yrJwuo7Mdn
         THlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c7HFrOGQ3phE12eoMeyUfOtwv87GN61OlvlGebweSPE=;
        b=bxv7pUmTisUVgD+MUMFJzRwz7jTOyA95aKv2lnmdVyt683eTmk5lOAk+hHrc00fyEm
         JUWSbjqtcPd5xfgOj9EORmlXwwrxOssY2VVyKUH3msazCFtTjFMiuU30JXwJqadflaph
         KXec1c4uiPvqEWkdHI/U8P9CzU8yYNnKbvo0bgXQVU6DrrI8C/MmKfPJ3frpcuDB5v9O
         Ys3q2nykxV1MWh4/XZ0Pjvt5KeWrUxmlmMbN2zUnWDGGY0C2uc3MH/e/QKqjRWgCJCk/
         GSY5WdUcFAtZMyXyoOPjcfx98yjYQ6IWFabZhUna3F8IvdTTPWcuDTtW6qIpikE+ZtV7
         cgmg==
X-Gm-Message-State: APjAAAVyKkpUTAaea+nQZ/TAFNaaBgpNZUiwcxk0mtGSWA5TElDm34Vv
        0BfM0CJQRD2yQe6Jj0oweVsYgg368fs77blTbaE=
X-Google-Smtp-Source: APXvYqzdwu5h+fnSlpdGrTkZ59bgP9nPDYS+jBNWRgOtKGV1J84qw+h5nryOcSbFDC8q8K7HsV9LDhKqwf7dQGAQUsU=
X-Received: by 2002:aca:1e11:: with SMTP id m17mr7953939oic.5.1578785910973;
 Sat, 11 Jan 2020 15:38:30 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a06985059be4002e@google.com>
In-Reply-To: <000000000000a06985059be4002e@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Jan 2020 15:38:19 -0800
Message-ID: <CAM_iQpWN-SKjjrG_7EQ-x+7UMiu6foaNWMJuwQuwN0BGmayB+A@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in __dev_queue_xmit
To:     syzbot <syzbot+ad4ea1dd5d26131a58a6@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, Alexander Aring <alex.aring@gmail.com>,
        allison@lohutok.net, andrew@lunn.ch,
        Andy Gospodarek <andy@greyhouse.net>,
        Taehee Yoo <ap420073@gmail.com>, ast@domdv.de,
        b.a.t.m.a.n@lists.open-mesh.org, bridge@lists.linux-foundation.org,
        cleech@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Greg KH <gregkh@linuxfoundation.org>, gustavo@embeddedor.com,
        haiyangz@microsoft.com, info@metux.net,
        Jay Vosburgh <j.vosburgh@gmail.com>, j@w1.fi,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        John Hurley <john.hurley@netronome.com>, jwi@linux.ibm.com,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Kalle Valo <kvalo@codeaurora.org>, kys@microsoft.com,
        linmiaohe@huawei.com,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-hams <linux-hams@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ppp@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-wpan@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Michal Kubecek <mkubecek@suse.cz>,
        mmanning@vyatta.att-mail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        oss-drivers@netronome.com, Paolo Abeni <pabeni@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz dup: WARNING: bad unlock balance in sch_direct_xmit
