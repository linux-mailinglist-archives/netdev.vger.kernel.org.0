Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81292FC365
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbhASW0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbhASW0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:26:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AC8C061575;
        Tue, 19 Jan 2021 14:25:45 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q2so41357164iow.13;
        Tue, 19 Jan 2021 14:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7zoJM+uNhdWvf1nHzEcFiYo9BG80GzQR83DQYjnEzw=;
        b=eil52VWTCcNdi++4F2dG/nMwfkcdE91k3nHfVG8GKbOw0SwqzOWfBUgUGRIRTkxIqA
         fLVNu6G3aJ548afzbytVlZPJMTl8wGbJaQ8KfCF+sqVN7opxIcsJ2IGN0sIxUYxSXLIy
         NIONX+zWUh0SOhOSotXhMFMLEcg6L4pLt9U/t11s0JlR/RliRRsBfAJwsetVvrfBoOdP
         f7wazaGsD1pW8VXo7YvMA1kIVPB+aXRZczruu1ftzmlRRJtL3b/mxT7/T2y8AC4taJm9
         x8mN3J8lqrcuYu4fjLE4O2E3WSP+vgbLmas6FN3rT/2a22EBOxz79NtHxJxE1cw9id5q
         JCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7zoJM+uNhdWvf1nHzEcFiYo9BG80GzQR83DQYjnEzw=;
        b=prLxjqn+el6tGuED66iO++hGHKW/BDa4JOUxwJxAC4Jk176JFpi8B57kNt/an4qGpl
         6szlY12lJW3zurQkGe70zm/JupRESVctkmlVlbEUvnH9DJo9K169Z14qIEG7INhhaM+O
         C0tXsrG8ThaKeeYd7XkVePEivovTNvwY4b0QGQkqEAqLJDM5iU8whHRDpMh1hh+ndq90
         JgZl7UW3jp6WBtuL9Qhg8GGNVcELyarP1QJhVwAkCNvMza6ILh8SYfCwvmH2DZHDOI2q
         Zw5qPrw6hHtn6m5ThpjCpaCLM3tvglLWHeGvD4m96zWcY9X0eTHlUdcs7x0p+RHAlTwm
         IC8g==
X-Gm-Message-State: AOAM532eaIlRGtJMvfouYG3pYuGFTGeRQFFscSpLAYFYnugJS5oEG3/h
        Dy6PU8HJdcazjt7iP8hvJyteAH0u3xYgKlCGLSk=
X-Google-Smtp-Source: ABdhPJzSh0zwo7rTqCixtlkjRTXkcsmO4VdPcYvUvCQTW0AwTAj8wdr2YAuGptKyS9szDJCfJiOLjgr5A9AUhS/ecKw=
X-Received: by 2002:a92:b6dd:: with SMTP id m90mr4638493ill.97.1611095144572;
 Tue, 19 Jan 2021 14:25:44 -0800 (PST)
MIME-Version: 1.0
References: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
 <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
 <cover.1610777159.git.lucien.xin@gmail.com> <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
 <c7cd3ae7df46d579a11c277f9cb258b7955415b2.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <c7cd3ae7df46d579a11c277f9cb258b7955415b2.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:25:31 -0800
Message-ID: <CAKgT0UdaXj9X47=ggSwTKt2zvG-Wcvtj-GSf9JZWcPaMGy+M2w@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: ixgbevf: use skb_csum_is_sctp instead
 of protocol check
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
> checksum offload packet, and yet it also makes ixgbevf support SCTP
> CRC checksum offload for UDP and GRE encapped packets, just as it
> does in igb driver.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
