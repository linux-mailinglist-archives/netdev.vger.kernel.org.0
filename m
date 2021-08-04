Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9AB3E0640
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbhHDQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbhHDQ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 12:59:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6FAC061799
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 09:59:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso708351pjb.5
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DzB6dBM5SyIcpGejg/63Uqs/X5dmV+wa8KKTjxwOlDk=;
        b=elh8Z5h5GzRR5b7783Cx0dhwrizOC59IPHBWGIWE8bnT+/IMf+0Bg2gi0UTFJRRH3F
         YC42cMDqWDv9vSrM1CcihXXv3RUj4zB2PLCmKp3AktRRu3z9b3C7TmwU9x7UqQpHm9Ap
         zYB0jsl24jB7scJwiVPWWYQx2eOEFeCuIjUHFXJcvBAz7AYH/f1lYu/mhb+FGExYQ/UN
         d06FxZSFhtXgGE4/Qabqlsr4i+exodHy2n0SuYBi8TcUWiSZQm4RZNZ9J8EsIuVfbVB6
         GPjCNTTGk51E1gWnpOp8HzB+h1hz1+Y4jDu77qJ7BKwxP6D+PiD47Md59VshymVuLgiz
         qIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DzB6dBM5SyIcpGejg/63Uqs/X5dmV+wa8KKTjxwOlDk=;
        b=VhkyXbJymAbdlAKu/Znta3LTAfxrsLjrO9rwEuocCdkzAXZnNXREVfxV/3DzXEsVuS
         x7T2ANG2h3yNsptoHZQa4G9j1fRJIEyjYNXvmwELgJMzsdJPsHaIadDd4vubnO/TSvhl
         hHaXAsfZa97AkxbwQvT6lgV+fVVYFGe9aSjLC0gfLj2IF/XeJzP+N8yXnqtS+mK7EeCd
         KyYnMcQo1/yk9D5UzqE4cj7KOuyjOHgcIA/0kG6tgkUZWkGyoa7Vhzv7DQZZvDYR7f1D
         keY6fclznJhreEJMkThncfM4eM8QBRQ1wRsb3s6xSQUok9R5W05Hy05Z8lgTM/J+OVzM
         yAfg==
X-Gm-Message-State: AOAM5339ga/gIzoKom6F/2hggtFreGKhjgxuwWnTfAUUOKAEqOBwzVuA
        zJoPEi27HUiZGspEFwA/7+8IPrNsYEvPrKOZF8330KKReRFUXw==
X-Google-Smtp-Source: ABdhPJxBDZBRBoO6b3cwY1vEKHNfDtLlNgKjUOgbH63wdn8V7qirac5keJOt8IkeRGyjwN7DliyPCeZatFxeLgouf24=
X-Received: by 2002:a17:903:32cd:b029:12c:18ad:7e58 with SMTP id
 i13-20020a17090332cdb029012c18ad7e58mr477132plr.67.1628096382775; Wed, 04 Aug
 2021 09:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com> <20210804160952.70254-3-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210804160952.70254-3-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 4 Aug 2021 19:09:25 +0200
Message-ID: <CAMZdPi_XZ84r4eXMOD0hXgmbRZw5bUx_R9Jw1VbHOQN4KgX_hg@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: wwan: iosm: endianness type correction
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 at 18:11, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> Endianness type correction for nr_of_bytes. This field is exchanged
> as part of host-device protocol communication.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
