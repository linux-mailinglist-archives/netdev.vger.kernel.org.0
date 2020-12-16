Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5F2DC760
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgLPTty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgLPTty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:49:54 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8982C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:49:13 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 23so51394360lfg.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WWKXoJMoZ5r2RetQnZaa8NUUoeCtz1QUvkBygcv55iQ=;
        b=sK9YiKzot8KbLkjyhfI/NhNzqy2rQy4tZ+S76CvUo92sLh2Ok9ZUMByNcOjlI7sPM8
         0jFShEbhbGGYxbvTMRy/QzekDFEXJJSbGfJU6gmtLpagV9177Sww/R95aBwi3YmaZTHL
         zrbqGQ3zV6JiZlvn0x2NjwBUKm/8GuYLuiN4eSf5tn6YOSFhrbrGzHrsaxNIwPdrfVEd
         4rUCV+whPw70IvTSgGJQN/N/QY/COilvYcLlyumdwr8ol+YRgFDrh24J2QiAgsLdzP7K
         aAq50pvil3Mw/PJVECqnHyIoo+DDG0mHAGUhZz/0TmfZcBL8jrLcRfoQhGLfGAljyi/v
         bAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WWKXoJMoZ5r2RetQnZaa8NUUoeCtz1QUvkBygcv55iQ=;
        b=cmR0ZWWVLTaIvBjUIWtxuC27tSwuiRfdh470yiEohwkRKMy79vgCiVpc1iAPBmGzHh
         Kdu7mWs99KhBMV0HWfB4X1nYLnWR6hoKnzPaJOg+S4Sx0Bfa+tdBKEPEhI3z0HnK+uIs
         llwWY5i5xJdrpjgesZ9aTBNrQuzCKmnw3i9R5s9ywiTjHQ9C5gIyjYea/blU8FbxmGSO
         qJ/7RJjbCGhXLCCsMxZlf9sY2DgIKj4NXI29bqvvijILeoD57tNz3ggRlquYLk1HJXYX
         WdRYMbkJSeHtlDR0wN4TqHjFVWyZc14DuH1Lallt4WkKb1bOLWAXvvtS7ymjdOZzaAbI
         8X3A==
X-Gm-Message-State: AOAM530fsxD/gwW8Q3HLy6Qudl1c8QJDIvsoxu1LV8zKJj5uf8O0dnub
        rPox7mByEE3CP1UZuIgzhuBGMK6aKd+49mKm
X-Google-Smtp-Source: ABdhPJxtboOHBLYR011Xi2DkeHEk70m6CJw4ofFnh6sbjEdat8/aKpBMuSy5zI86Jn1RwNqb0L9HrA==
X-Received: by 2002:ac2:5b4f:: with SMTP id i15mr8230341lfp.572.1608148151639;
        Wed, 16 Dec 2020 11:49:11 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id q6sm328718lfc.56.2020.12.16.11.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:49:11 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
In-Reply-To: <20201216180248.u3uhrec2ssveubyp@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com> <20201216160056.27526-4-tobias@waldekranz.com> <20201216180248.u3uhrec2ssveubyp@skbuf>
Date:   Wed, 16 Dec 2020 20:49:10 +0100
Message-ID: <87mtydbkg9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 20:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
>> +	/* Drivers that benefit from having an ID associated with each
>> +	 * offloaded LAG should set this to the maximum number of
>> +	 * supported IDs. DSA will then maintain a mapping of _at
>> +	 * least_ these many IDs, accessible to drivers via
>> +	 * dsa_tree_lag_id().
>            ~~~~~~~~~~~~~~~
>            you named it dsa_lag_id() in the end.
>
>> +	 */
>> +	unsigned int		num_lag_ids;
> [...]
>> +	/* No IDs left, which is OK. Some drivers do not need it. The
>> +	 * ones that do, e.g. mv88e6xxx, will discover that
>> +	 * dsa_tree_lag_id returns an error for this device when
>            ~~~~~~~~~~~~~~~
>            same thing here.
>
>> +	 * joining the LAG. The driver can then return -EOPNOTSUPP
>> +	 * back to DSA, which will fall back to a software LAG.
>> +	 */

Right, will fix!
