Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8819085E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 09:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCXI4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 04:56:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35968 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgCXI4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 04:56:09 -0400
Received: by mail-ed1-f66.google.com with SMTP id b18so19845118edu.3;
        Tue, 24 Mar 2020 01:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2/2BeGLfOXUYC+AjdgCFRQqF06zHm6BUh3zIA84yC4=;
        b=rloMJQCzcKN/KWDmwLQrsQutxGlUJgYqDAzryx/3G4oOZC2N1awjEZzucypp+QD61U
         TvkYuCH7ljj+rELuWdmCC5U10/Q5u34SoS1BoE70sglMcdEj19wYjWyj0MHjTDtUxWIr
         QKro/WjjMZq4b7wyrpVqOIGOiI5KmjRFqHb0KAIcHINkDB9jI5Lmp9WXZsBytza30CCx
         BNc68v6x2p04dm1qZaXQLBnIEgBENOiWB5HMIkyfprpOY30mb/CSU4hjhAOIpCEbuRyN
         tj+aVfHZmApijYKIKJS1fI0mlinmIvT30agCkMa9wa7zqhZAaupAypnePtZoXWz2OBK1
         sM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2/2BeGLfOXUYC+AjdgCFRQqF06zHm6BUh3zIA84yC4=;
        b=OrnC010OPrZaKUW65TEL0sKvyqORKHvN+LZ0GFuuCbeYaPZL9RBCoR4M5czJReXMRB
         ZEjPNBVJa0/MYMYIwMJ2n//IbCvfS1faiwXMKo6mBtbe6hikxnaFRX1Obx5SWyAG+Mjc
         YCAuNQ3ogvEwNcqrDUDECfUyISHAyxt5OPBZHo2LHkBzx45W0Hl63STOYRfXC/AloLEM
         gZOKv+7rJW8+Xjakain3geRdyMorTT3qeO+hiGllU0r00rO6/tROqoLpxj9B18kVeWwX
         d04lhHl1TdIxoWabS3ADcX01FKEsFvKSpjkFVOYyoDhVBZEE9/S9ySeT6lJ0oPfEv5DY
         skkQ==
X-Gm-Message-State: ANhLgQ2zZ4JIytNUVa07RpHhix2c8Wjm7w9jUbNgLLLnD5ayfW+ca/6j
        XuQNTMSgx6mwIgcnEgVGB6k1Hk1oa0xxVgf/rjo=
X-Google-Smtp-Source: ADFU+vvsP5HOedXd+hegnFMtwBS/teEifGoBsmUf55otvjlxomK8pkefcU1jQBRm2y+tXxXqlpA0ZrwxShfpB5I+sAA=
X-Received: by 2002:a05:6402:1c0c:: with SMTP id ck12mr25647923edb.145.1585040166289;
 Tue, 24 Mar 2020 01:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200324041920.GA7068@asgard.redhat.com>
In-Reply-To: <20200324041920.GA7068@asgard.redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 24 Mar 2020 10:55:55 +0200
Message-ID: <CA+h21hrB6JUcM87Lv_V-gMdyVOCncJ9yhRmtVGgWt6eB0MhSow@mail.gmail.com>
Subject: Re: [PATCH net-next] taprio: do not use BIT() in TCA_TAPRIO_ATTR_FLAG_*
 definitions
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

On Tue, 24 Mar 2020 at 06:19, Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> BIT() macro definition is internal to the Linux kernel and is not
> to be used in UAPI headers; replace its usage with the _BITUL() macro
> that is already used elsewhere in the header.
>
> Cc: <stable@vger.kernel.org> # v5.4+
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---

I see this mirrors what was done in commit

commit 9903c8dc734265689d5770ff28c84a7228fe5890
Author: Vedang Patel <vedang.patel@intel.com>
Date:   Tue Jun 25 15:07:13 2019 -0700

    etf: Don't use BIT() in UAPI headers.

    The BIT() macro isn't exported as part of the UAPI interface. So, the
    compile-test to ensure they are self contained fails. So, use _BITUL()
    instead.

    Signed-off-by: Vedang Patel <vedang.patel@intel.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

so

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  include/uapi/linux/pkt_sched.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index bbe791b..0e43f67 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1197,8 +1197,8 @@ enum {
>   *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
>   */
>
> -#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST     BIT(0)
> -#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD      BIT(1)
> +#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST     _BITUL(0)
> +#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD      _BITUL(1)
>
>  enum {
>         TCA_TAPRIO_ATTR_UNSPEC,
> --
> 2.1.4
>

Regards,
-Vladimir
