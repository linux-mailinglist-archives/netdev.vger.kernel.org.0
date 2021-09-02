Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E93FF226
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346539AbhIBRRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346521AbhIBRRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:17:35 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C23C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 10:16:36 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k13so5918493lfv.2
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFMUfBmbSDNmL0+hEJjSMckWq+RWBRj7DJeWmAldrvU=;
        b=HEjM3l8FT7i8s8RTsYSL9OPwwq7dJPL28z4Egg4c2fboPKc4808uvyuJoYMICE5pmO
         0+g+S9AdEVa/wr8F04JeXsa7JKLL1+mKN3eXopoMdHwKKjq38D4IuC66Mp7u4LnE4E/t
         ADQ53/+/iZb1B36anEatqClmIlmm6vR4ZV3i4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFMUfBmbSDNmL0+hEJjSMckWq+RWBRj7DJeWmAldrvU=;
        b=haSSnjhEKRCuwXsj2vNcJSVDmlv0dFRpUu2R2Nn6y4ep5zUOMZkJpbTa3nIdSvicEZ
         jQT2IzOI5ViJoEjsB75qnUopU4ve0oUMiJ+AtTldo3RQkzPCOqZZIQASTxe+riKF18Bf
         zCF4nRyvi46uKJRKf48k5Q/Ku9kgI+loQa3MJMyH4jWRmMJA2GNXsE4ycwGS0HHo9kXO
         Z2Hw7XLG5K/XBmIALSgBJoK3P+73lkVcPSA/OgbIrdvUsNGcbJF7mUtq8VGR+HEpYFDW
         N+RC8ZzckLADuepqYExIYyZU6BZ45p9u8wiBQ+jptYORIDQr3q6IYQYS54iutUcPx4PO
         OPnA==
X-Gm-Message-State: AOAM530/cj9xv9bqWL9uKB6Gb1hDNBlgXKH9c0bAbHvYcbBkdi2n91l+
        u8XiXoFifUYgG276Vx9cPIZCGLq7A+LM0JBkCI8=
X-Google-Smtp-Source: ABdhPJxGXX5l+8zwZvaE8CzDrZCsbi4eDCYm2mwSOeII1ZStUB3t5vpLxn5PyHGhcZjHWiwBbrHVLg==
X-Received: by 2002:ac2:5d49:: with SMTP id w9mr3358733lfd.450.1630602994405;
        Thu, 02 Sep 2021 10:16:34 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id w17sm285709lji.115.2021.09.02.10.16.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 10:16:30 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id s3so4880546ljp.11
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:16:30 -0700 (PDT)
X-Received: by 2002:a05:651c:1144:: with SMTP id h4mr3404930ljo.48.1630602990323;
 Thu, 02 Sep 2021 10:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210831203727.3852294-1-kuba@kernel.org> <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
 <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
 <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com> <CAP71bdV1eBm3f1qY0rfigK4VaW5icZ+hU0pw7g6fVM=hGbn7Xw@mail.gmail.com>
In-Reply-To: <CAP71bdV1eBm3f1qY0rfigK4VaW5icZ+hU0pw7g6fVM=hGbn7Xw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 10:16:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=whog7gH+7TZ+QfB-U=mbqg4QkHB6eNad9DjPX0hgheydw@mail.gmail.com>
Message-ID: <CAHk-=whog7gH+7TZ+QfB-U=mbqg4QkHB6eNad9DjPX0hgheydw@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for v5.15
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:07 AM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> I can confirm that Luca's patch fixes the problem on my system.

Yes. It's merged in my tree as commit 75ae663d053b ("iwlwifi: mvm: add
rtnl_lock() in iwl_mvm_start_get_nvm()"), and I no longer see the
complaints.

           Linus
