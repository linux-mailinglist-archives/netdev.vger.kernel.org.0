Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591F339B7C7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhFDLVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:21:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhFDLVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622805576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEMgaoLeL6tcvz8xfcXaMYclNBrnP/Gg/ldLfLwkX5k=;
        b=Hdi2lYqniitO/wNDcjiebH8TIqYFhm8G13AzDnis+z1bClmp+TneQdExIntVIPge9aNCi1
        bINwVhG5RS33QhQQFMFZp/rsMImcwmnZN9r7+2Q9ZFe0y5jmLWLhu4tk0n29evgtYiknfb
        lbg8rfYgEzhepLces0hGSbSSZUb5ths=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Zz8FPdVxPBSKrzik_nLaGw-1; Fri, 04 Jun 2021 07:19:35 -0400
X-MC-Unique: Zz8FPdVxPBSKrzik_nLaGw-1
Received: by mail-il1-f200.google.com with SMTP id s5-20020a056e021a05b02901e07d489107so6198558ild.3
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 04:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wEMgaoLeL6tcvz8xfcXaMYclNBrnP/Gg/ldLfLwkX5k=;
        b=KLF3CC8xXfqdNfvbtBrginKB/Kvtp7N+Llq24TvSjXZVFgiL/JSAye6HRtTOO/3mt0
         MvE+P5s+VOa5frJQbJGJcxyiqjJd2dS3sOsGw+/pBTftyLprpVTqRWf0TvxkcFxrwCXS
         2JriFKPmjOpmNxzEjwOIDXRcv4n7ii8XfA1t//+MS47hgN9SH75p3we/FX2qEGNbqkZ2
         bTWo4rwmMpb74uaykpTTflWy2LL5Yv6l1Uoxz6bsjIcWXNy+UOQdnMukg1QrPxXmRMiy
         2gSN9iDZ7XqL/xS9y1MKRgrqEHfR2fvTSt2AsayXKYkzsMZkyji4Z720Yx7FKD4bkNwG
         igdQ==
X-Gm-Message-State: AOAM5308W0OvQutoaim+D+DPIGZ0WmtRiKZS6dl5HIuxXppshEWesmZv
        JzDzXcE5nOYtRR+wXVZHCQZoHONFcn0gI+URFgnxpiiL+AsAGbg7gVg9YxO632jmacPjDnQtxyI
        e6YPK1mbwvQLiOxSKCUlg0GmNG7SePQdd
X-Received: by 2002:a92:ce45:: with SMTP id a5mr1296342ilr.173.1622805574645;
        Fri, 04 Jun 2021 04:19:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSCuGCc+ls84G/wdEtzgp1+rIGRW2rppNSQVthsvLpqCJlAFDBGigeXmp/uivXjtB2Q55nDCYfmjLBE/qVVxY=
X-Received: by 2002:a92:ce45:: with SMTP id a5mr1296324ilr.173.1622805574448;
 Fri, 04 Jun 2021 04:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210603063430.6613-1-ihuguet@redhat.com> <20210603074419.2930-1-hdanton@sina.com>
 <CACT4oudUd2YuV=GFhz1asvwX8h_mGtqzjZygBD26Tj98cxfCpw@mail.gmail.com> <20210604031450.3039-1-hdanton@sina.com>
In-Reply-To: <20210604031450.3039-1-hdanton@sina.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 4 Jun 2021 13:19:23 +0200
Message-ID: <CACT4ouccprqnx_Dt4dk8SvFrdW9OmnyRxC9KAM7q6n7925umHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net:cxgb3: replace tasklets with works
To:     Hillf Danton <hdanton@sina.com>
Cc:     rajur@chelsio.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 5:15 AM Hillf Danton <hdanton@sina.com> wrote:
> Good material to be shoehorned into commit message though without sheding
> any light first on the reasons why CTRL is so special its work wont bothe=
r
> being canceled.

Not sure what you mean. If it's that CTRL work isn't being cancelled,
but OFLD is being cancelled twice, thanks for pointing it. I'm sending
a new patch.

> How long? Long enough for the kworker to become a CPU hog?
> What is it in your opinion to cut the chance for that risk?

I don't think so, not by its own, but the maybe yes the sum of many
tasks in softirq context (it will depend on what else is being
executed in the system). As far as I know, moving work from softirq to
threads to reduce latencies is seen as a good thing, unless it's
really necessary.
--=20
=C3=8D=C3=B1igo Huguet

