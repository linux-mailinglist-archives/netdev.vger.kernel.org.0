Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC82115E14
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 19:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfLGS5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 13:57:32 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35708 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfLGS5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 13:57:32 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so4097885plp.2
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 10:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKy+XX4GYCABGBbFJLACLqmcw44M8JXKiURp4lg4W1o=;
        b=tWGwFAQTQnmJJWJVMPmxFOC/nCVsVKcWnksCrV4Mf4REVw0tBrgWAk03NT2ycEbCLO
         euZhOd7RopjsFRlkKJalvfYHcWWYCm2M2xGGVcz4vHpnGhNucnm70tRvaWL3E9YqYFTZ
         JpQV55sKFfRV0pNSQs4KJmI5p1fGpdenCUnF4sFPpLq60COWF1jwwsqGkLRxGiWFRywO
         /QEbPBRoWC2Zq3TqcdOV7a8CMp5nEh6u+gQKEMmEhpRyAuL2FCYr5rck/yQ4qMJzgcZI
         r+bQq+DB39JSL0tltoeT4jtl+GQXH5mEFelWYgCrO86RqV2I4XE5QlwnlCB1w2aDPlWt
         CODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKy+XX4GYCABGBbFJLACLqmcw44M8JXKiURp4lg4W1o=;
        b=WQQlCQRPOvQlU+OuoJno2t/nSG5Cj3wgfOHmpShxfNKlALCLbNtAVwt1/LyFqx9Fai
         0PoqbdiawvFjJC7tj5duYnP3Ufj6nJy+X4OuE2fPXdMjy3ilOC++F2IZ3RbqspOQwqzm
         6BWuKCRMcU1StJfVjSLrov1qInzxYsCJ9FnlVqvPpAnYT/LVqDIYvVCgXFRBCsbe52H2
         kWuKLDoOtPfvKRdYl55lPam/lfs83Rq5s6n4JitT262D/YtrDCO++r1+taCp9JXinYc9
         mfSReX+qrhljCl/eVWZaz9Ts+tUh3tlMtdmWwU2BiJXR5R25a7uAlNJ1kwoUdDS7tvLE
         6vbQ==
X-Gm-Message-State: APjAAAVTvyQpvVvxg4Nfzqcjd+5pYfSl5IURnF/7BUEw3dWu4awfe6AE
        byKZY20Nd2X43WfInI7F9MIzNsEpDvyN8+AloxA=
X-Google-Smtp-Source: APXvYqzsvuBzMK74M5/jjpjkKep3vOrhBuWgTXW7Q0d80WQaRoVOfFTbk/NcSzTQTU89lIxxJvHtM7xSYV6zPyYXrLg=
X-Received: by 2002:a17:90a:200d:: with SMTP id n13mr23488696pjc.16.1575745051491;
 Sat, 07 Dec 2019 10:57:31 -0800 (PST)
MIME-Version: 1.0
References: <20191207184930.130132-1-edumazet@google.com>
In-Reply-To: <20191207184930.130132-1-edumazet@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 7 Dec 2019 10:57:20 -0800
Message-ID: <CAM_iQpVE5-59QPiP3Od7p-Fkjwjcm5QYrncN0LofWEC+TPTZUw@mail.gmail.com>
Subject: Re: [PATCH net] net_sched: validate TCA_KIND attribute in tc_chain_tmplt_add()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 7, 2019 at 10:49 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Use the new tcf_proto_check_kind() helper to make sure user
> provided value is well formed.
...
> Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Just a nit: the extack message should be for a chain template, not
for a TC filter.

Thanks.
