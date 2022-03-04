Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B537C4CE039
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiCDWZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiCDWZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:25:33 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E231C8871
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:24:45 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p17so8946642plo.9
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 14:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y+6/vmIuHY8eQXWAKyocNaQeGDTm4yWucBqdOm+hmlU=;
        b=TjgqnYIcwLonWwRmuAVErGGJMqrgKj6+7tLdzrCtpUsgIpe2PFIEcAve8fTMHqPjcl
         CXNQBHk4BEw5bGc58Mfv+r9JaEUef5k2LvpDRYgWlkci/D82qFKlMcAJrWUdzN5J9EsC
         GfBYlvkTQtYvkpbhQy0XogAvedNi3ydE75H65zJigK0BKP0D9CzvGpUV8hJbHuG53fIi
         n4diews8pfuGfbOjqb26U51FFQ1jd1pYf3EEq8hiu5WBssufA/WFQRGYHEki/s/gwNs+
         c5Y9gBx/YYxcFedVnMF34/0NKuIWRfWn11vJxviJyDMlCOuacrmHsWydxXoqyKc9PukW
         BkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y+6/vmIuHY8eQXWAKyocNaQeGDTm4yWucBqdOm+hmlU=;
        b=6qkXpfxqLGddFJbwCJCAcy2sHS7Y7toGXeyVJYqCuhr7OqD++w+lucio2r7kyiKd8/
         2EMkLasC6jUT4yZnQ6BM4W96/VYsFMfgDApEjAqiK8wP5hHHnlBU35Vi+amFAMLCu2ey
         TnyVxH9w6TFIVq2jaFcc+AhRFpLJiUVdIrh0IpQhT1XKrhL8TUNmqW2QgFWJYUyOLPbS
         6ahA+jU+jRGo/QoWQf88nsx+oCN22wGBVi8jZM9zaeqzSN1ADeEMgpO3vCYgtnq21pJd
         8o8xVWDQMDZeUtYvT66wXxWdhnQQcepH9KlN6gSAbJeblNnvRzZrY8rK9rBs9xr+C7tB
         4eFA==
X-Gm-Message-State: AOAM531qXkbXo0Yo7wV4TJjNH8wdysSyFbtu2PMQgfZgp94NtVczP6wf
        Ama7v9JmS2rB/EzV84rdlf8ZOTCZ9d5NdQ==
X-Google-Smtp-Source: ABdhPJzCk1eWOR/HXK3v6JC7Qsv3fR1FKKRjdRGz4DHJfuqo7mNF/UjOvpIodsFXOFsZZXDKS0mCtQ==
X-Received: by 2002:a17:902:ab52:b0:14d:7ce1:8d66 with SMTP id ij18-20020a170902ab5200b0014d7ce18d66mr730569plb.88.1646432684674;
        Fri, 04 Mar 2022 14:24:44 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm7421270pfh.21.2022.03.04.14.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 14:24:44 -0800 (PST)
Date:   Fri, 4 Mar 2022 14:24:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     maxime.deroucy@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ipaddress: remove 'label' compatibility
 with Linux-2.0 net aliases
Message-ID: <20220304142441.342f3156@hermes.local>
In-Reply-To: <f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com>
References: <f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Mar 2022 23:14:55 +0100
maxime.deroucy@gmail.com wrote:

> As Linux-2.0 is getting old and systemd allows non Linux-2.0 compatible
> aliases to be set, I think iproute2 should be able to manage such
> aliases.
> ---
> =C2=A0ip/ipaddress.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 16 ----------------
> =C2=A0man/man8/ip-address.8.in |=C2=A0 3 ---
> =C2=A02 files changed, 19 deletions(-)

Sorry, this patch is missing Signed-off-by:

Please resubmit and run it through checkpatch to make sure it
is correct format.

ERROR: patch seems to be corrupt (line wrapped?)
#93: FILE: ip/ipaddress.c:2348:
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return false;

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 0 warnings, 43 lines checked
