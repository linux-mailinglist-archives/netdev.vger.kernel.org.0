Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AA3520B16
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiEJCWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiEJCWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:22:05 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F45293B43
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:18:09 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l15so10515472ilh.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wtvbdm5RoaA8oDIBKyDNKWt9MnB6vy/mwNf4axxFeBk=;
        b=oItulGg9BGZBdDyin3sZYsYFYznrZztbhi/KZysNi7IXJl/SGx49xwPpZsU0Vvl4fR
         1uAv6SWUEBSbodqoCpeRYnpdZ5KKjGYIuJ02Iuh2T6hIkTFjUsh5PYSp3uaFkVcnzZJC
         hgWZO7FM5WGgzQP3UsTbb+RLTsrd9f0Af7wNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wtvbdm5RoaA8oDIBKyDNKWt9MnB6vy/mwNf4axxFeBk=;
        b=5C4LbFbK68sEK7RXF9DXz0aR9Yhi62F38YpYMnWlyNUILpu/5NEo8+wZhx632hjSXa
         VDsBUNWkv4TQLHtbet8vx+HMC56HQJ7OBO1zNWsJfug0UVy2Gxuxy3sus1zenP2zWwMx
         hSPi0U8J6POXLIIKzF5VCzOyuNWFtFNp+igfNllZXJ3leGnGvjAC4RtuGdrvbQygeQJI
         jSMwRRjZ+ydwSbayjia2XF49VSidXX5/xdnSpq/leUEozyizq/fst9oJpfdSVnhBwwhV
         LwOpIJKNHgOFS18hi4vFoATz5CdyouqhTYnRkZLsPsmMX5etxzg+wvy8ongEnQAaKoVM
         cwog==
X-Gm-Message-State: AOAM5332K9exUmTZiguEXkUD0M96hKbactZY/s6njFgTmtutPXV67aqh
        UtKVGX+vmb5G0zDiIqOLTOQ7dGZ5miCIdgunP6H7JIV/VZ7paw==
X-Google-Smtp-Source: ABdhPJySvIoH96yNR86Q/snGnbAX8RhlrPzfmxUrP3c2xmurI7eieZMg/IBEEQaJ0WpNrpWIrYlZaVzSFLnADXVtZBM=
X-Received: by 2002:a92:c567:0:b0:2cf:592e:f8ed with SMTP id
 b7-20020a92c567000000b002cf592ef8edmr7569982ilj.205.1652149088768; Mon, 09
 May 2022 19:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
 <e824a9d7-7d30-c9e6-fc27-65af0dcd958b@quicinc.com> <CAB5ih=O325ndrYqLWwug01tSmketLDrsJgtX5DvR38Om6T8ZCQ@mail.gmail.com>
In-Reply-To: <CAB5ih=O325ndrYqLWwug01tSmketLDrsJgtX5DvR38Om6T8ZCQ@mail.gmail.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Mon, 9 May 2022 19:17:56 -0700
Message-ID: <CACTWRwsru+TFTMnqp1+MxwMYqvE7m16W5OXWCTCGwX9rpk+XNg@mail.gmail.com>
Subject: Re: [PATCH v3] ath10k: improve BDF search fallback strategy
To:     Abhishek Kumar <kuabhs@google.com>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>, kvalo@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replying again ...

Thanks for the review Jeff, I have replied below and will address
these comments in next iteration. I will wait for a day more to get
some more reviews and collectively make the change.

On Mon, May 9, 2022 at 10:22 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>
> On 5/8/2022 7:26 PM, Abhishek Kumar wrote:
> > Board data files wrapped inside board-2.bin files are
> > identified based on a combination of bus architecture,
> > chip-id, board-id or variants. Here is one such example
> > of a BDF entry in board-2.bin file:
> > bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> > It is possible for few platforms none of the combinations
> > of bus,qmi-board,chip-id or variants match, e.g. if
> > board-id is not programmed and thus reads board-id=0xff,
> > there won't be any matching BDF to be found. In such
> > situations, the wlan will fail to enumerate.
> >
> > Currently, to search for BDF, there are two fallback
> > boardnames creates to search for BDFs in case the full BDF
> > is not found. It is still possible that even the fallback
> > boardnames do not match.
> >
> > As an improvement, search for BDF with full BDF combination
> > and perform the fallback searches by stripping down the last
> > elements until a BDF entry is found or none is found for all
> > possible BDF combinations.e.g.
> > Search for initial BDF first then followed by reduced BDF
> > names as follows:
> > bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> > bus=snoc,qmi-board-id=67,qmi-chip-id=320
> > bus=snoc,qmi-board-id=67
> > bus=snoc
> > <No BDF found>
> >
> > Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > ---
> >
> > Changes in v3:
> > - As discussed, instead of adding support for default BDF in DT, added
> > a method to drop the last elements from full BDF until a BDF is found.
> > - Previous patch was "ath10k: search for default BDF name provided in DT"
> >
> >   drivers/net/wireless/ath/ath10k/core.c | 65 +++++++++++++-------------
> >   1 file changed, 32 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > index 688177453b07..ebb0d2a02c28 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -1426,15 +1426,31 @@ static int ath10k_core_search_bd(struct ath10k *ar,
> >       return ret;
> >   }
> >
> > +static bool ath10k_create_reduced_boardname(struct ath10k *ar, char *boardname)
> > +{
> > +     /* Find last BDF element */
> > +     char *last_field = strrchr(boardname, ',');
> > +
> > +     if (last_field) {
> > +             /* Drop the last BDF element */
> > +             last_field[0] = '\0';
> > +             ath10k_dbg(ar, ATH10K_DBG_BOOT,
> > +                        "boardname =%s\n", boardname);
>
> nit: strange spacing in the message. i'd expect consistent spacing on
> both side of "=", either one space on both sides or no space on both
> sides.  also the use of "=" here is inconsistent with the use of ":" in
> a log later below

Ack, will fix this in the next iteration.
>
>
> > +             return 0;
> > +     }
> > +     return -ENODATA;
> > +}
> > +
> >   static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
> >                                             const char *boardname,
> > -                                           const char *fallback_boardname1,
> > -                                           const char *fallback_boardname2,
> >                                             const char *filename)
> >   {
> > -     size_t len, magic_len;
> > +     size_t len, magic_len, board_len;
> >       const u8 *data;
> >       int ret;
> > +     char temp_boardname[100];
> > +
> > +     board_len = 100 * sizeof(temp_boardname[0]);
> >
> >       /* Skip if already fetched during board data download */
> >       if (!ar->normal_mode_fw.board)
> > @@ -1474,20 +1490,24 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
> >       data += magic_len;
> >       len -= magic_len;
> >
> > -     /* attempt to find boardname in the IE list */
> > -     ret = ath10k_core_search_bd(ar, boardname, data, len);
> > +     memcpy(temp_boardname, boardname, board_len);
> > +     ath10k_dbg(ar, ATH10K_DBG_BOOT, "boardname :%s\n", boardname);
>
> nit: use of ":" inconsistent with use of "=" noted above.
> also expect space after ":, not before: "boardname: %s\n"
>
Ack, will remove the extra space.
>
>
> >
> > -     /* if we didn't find it and have a fallback name, try that */
> > -     if (ret == -ENOENT && fallback_boardname1)
> > -             ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
> > +retry_search:
> > +     /* attempt to find boardname in the IE list */
> > +     ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
> >
> > -     if (ret == -ENOENT && fallback_boardname2)
> > -             ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
> > +     /* If the full BDF entry was not found then drop the last element and
> > +      * recheck until a BDF is found or until all options are exhausted.
> > +      */
> > +     if (ret == -ENOENT)
> > +             if (!ath10k_create_reduced_boardname(ar, temp_boardname))
> > +                     goto retry_search;
> >
> >       if (ret == -ENOENT) {
>
> note that ath10k_create_reduced_boardname() returns -ENODATA when
> truncation fails and hence you won't log this error when that occurs

Hmmm, I think it makes sense to log each failure to find as a debug
log and log as err only if nothing matches (when ENODATA is returned).
>
>
> >               ath10k_err(ar,
> >                          "failed to fetch board data for %s from %s/%s\n",
> > -                        boardname, ar->hw_params.fw.dir, filename);
> > +                        temp_boardname, ar->hw_params.fw.dir, filename);
>
> does it really make sense to log the last name tried, temp_boardname? or
> does it make more sense to still log the original name, boardname?

Thinking about it a bit more, it makes sense to log the original name
rather than last name.
>
>
> maybe log each failure in the loop, before calling
> ath10k_create_reduced_boardname()?

As mentioned above, it makes sense to log as debug for each failure to
find and log as error if nothing matches, will make this change in the
next iteration.

>               ret = -ENODATA;
>       }
>
> @@ -1566,7 +1586,7 @@ static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
>
>   int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>   {
> -     char boardname[100], fallback_boardname1[100], fallback_boardname2[100];
> +     char boardname[100];
>       int ret;
>
>       if (bd_ie_type == ATH10K_BD_IE_BOARD) {
> @@ -1579,25 +1599,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>                       return ret;
>               }
>
> -             /* Without variant and only chip-id */
> -             ret = ath10k_core_create_board_name(ar, fallback_boardname1,
> -                                                 sizeof(boardname), false,
> -                                                 true);
> -             if (ret) {
> -                     ath10k_err(ar, "failed to create 1st fallback board name: %d",
> -                                ret);
> -                     return ret;
> -             }
> -
> -             /* Without variant and without chip-id */
> -             ret = ath10k_core_create_board_name(ar, fallback_boardname2,
> -                                                 sizeof(boardname), false,
> -                                                 false);
> -             if (ret) {
> -                     ath10k_err(ar, "failed to create 2nd fallback board name: %d",
> -                                ret);
> -                     return ret;
> -             }
>       } else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
>               ret = ath10k_core_create_eboard_name(ar, boardname,
>                                                    sizeof(boardname));
> @@ -1609,8 +1610,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>
>       ar->bd_api = 2;
>       ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
> -                                              fallback_boardname1,
> -                                              fallback_boardname2,
>                                                ATH10K_BOARD_API2_FILE);
>       if (!ret)
>               goto success;
-Abhishek

On Mon, May 9, 2022 at 7:04 PM Abhishek Kumar <kuabhs@google.com> wrote:
>
> Thanks for the review Jeff, I have replied below and will address these comments in next iteration. I will wait for a day more to get some more reviews and collectively make the change.
>
> On Mon, May 9, 2022 at 10:22 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>>
>> On 5/8/2022 7:26 PM, Abhishek Kumar wrote:
>> > Board data files wrapped inside board-2.bin files are
>> > identified based on a combination of bus architecture,
>> > chip-id, board-id or variants. Here is one such example
>> > of a BDF entry in board-2.bin file:
>> > bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
>> > It is possible for few platforms none of the combinations
>> > of bus,qmi-board,chip-id or variants match, e.g. if
>> > board-id is not programmed and thus reads board-id=0xff,
>> > there won't be any matching BDF to be found. In such
>> > situations, the wlan will fail to enumerate.
>> >
>> > Currently, to search for BDF, there are two fallback
>> > boardnames creates to search for BDFs in case the full BDF
>> > is not found. It is still possible that even the fallback
>> > boardnames do not match.
>> >
>> > As an improvement, search for BDF with full BDF combination
>> > and perform the fallback searches by stripping down the last
>> > elements until a BDF entry is found or none is found for all
>> > possible BDF combinations.e.g.
>> > Search for initial BDF first then followed by reduced BDF
>> > names as follows:
>> > bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
>> > bus=snoc,qmi-board-id=67,qmi-chip-id=320
>> > bus=snoc,qmi-board-id=67
>> > bus=snoc
>> > <No BDF found>
>> >
>> > Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
>> > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
>> > ---
>> >
>> > Changes in v3:
>> > - As discussed, instead of adding support for default BDF in DT, added
>> > a method to drop the last elements from full BDF until a BDF is found.
>> > - Previous patch was "ath10k: search for default BDF name provided in DT"
>> >
>> >   drivers/net/wireless/ath/ath10k/core.c | 65 +++++++++++++-------------
>> >   1 file changed, 32 insertions(+), 33 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> > index 688177453b07..ebb0d2a02c28 100644
>> > --- a/drivers/net/wireless/ath/ath10k/core.c
>> > +++ b/drivers/net/wireless/ath/ath10k/core.c
>> > @@ -1426,15 +1426,31 @@ static int ath10k_core_search_bd(struct ath10k *ar,
>> >       return ret;
>> >   }
>> >
>> > +static bool ath10k_create_reduced_boardname(struct ath10k *ar, char *boardname)
>> > +{
>> > +     /* Find last BDF element */
>> > +     char *last_field = strrchr(boardname, ',');
>> > +
>> > +     if (last_field) {
>> > +             /* Drop the last BDF element */
>> > +             last_field[0] = '\0';
>> > +             ath10k_dbg(ar, ATH10K_DBG_BOOT,
>> > +                        "boardname =%s\n", boardname);
>>
>> nit: strange spacing in the message. i'd expect consistent spacing on
>> both side of "=", either one space on both sides or no space on both
>> sides.  also the use of "=" here is inconsistent with the use of ":" in
>> a log later below
>
> Ack, will fix this in the next iteration.
>>
>>
>> > +             return 0;
>> > +     }
>> > +     return -ENODATA;
>> > +}
>> > +
>> >   static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>> >                                             const char *boardname,
>> > -                                           const char *fallback_boardname1,
>> > -                                           const char *fallback_boardname2,
>> >                                             const char *filename)
>> >   {
>> > -     size_t len, magic_len;
>> > +     size_t len, magic_len, board_len;
>> >       const u8 *data;
>> >       int ret;
>> > +     char temp_boardname[100];
>> > +
>> > +     board_len = 100 * sizeof(temp_boardname[0]);
>> >
>> >       /* Skip if already fetched during board data download */
>> >       if (!ar->normal_mode_fw.board)
>> > @@ -1474,20 +1490,24 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>> >       data += magic_len;
>> >       len -= magic_len;
>> >
>> > -     /* attempt to find boardname in the IE list */
>> > -     ret = ath10k_core_search_bd(ar, boardname, data, len);
>> > +     memcpy(temp_boardname, boardname, board_len);
>> > +     ath10k_dbg(ar, ATH10K_DBG_BOOT, "boardname :%s\n", boardname);
>>
>> nit: use of ":" inconsistent with use of "=" noted above.
>> also expect space after ":, not before: "boardname: %s\n"
>>
> Ack, will remove the extra space.
>>
>>
>> >
>> > -     /* if we didn't find it and have a fallback name, try that */
>> > -     if (ret == -ENOENT && fallback_boardname1)
>> > -             ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
>> > +retry_search:
>> > +     /* attempt to find boardname in the IE list */
>> > +     ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
>> >
>> > -     if (ret == -ENOENT && fallback_boardname2)
>> > -             ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
>> > +     /* If the full BDF entry was not found then drop the last element and
>> > +      * recheck until a BDF is found or until all options are exhausted.
>> > +      */
>> > +     if (ret == -ENOENT)
>> > +             if (!ath10k_create_reduced_boardname(ar, temp_boardname))
>> > +                     goto retry_search;
>> >
>> >       if (ret == -ENOENT) {
>>
>> note that ath10k_create_reduced_boardname() returns -ENODATA when
>> truncation fails and hence you won't log this error when that occurs
>
> Hmmm, I think it makes sense to log each failure to find as a debug log and log as err only if nothing matches (when ENODATA is returned).
>>
>>
>> >               ath10k_err(ar,
>> >                          "failed to fetch board data for %s from %s/%s\n",
>> > -                        boardname, ar->hw_params.fw.dir, filename);
>> > +                        temp_boardname, ar->hw_params.fw.dir, filename);
>>
>> does it really make sense to log the last name tried, temp_boardname? or
>> does it make more sense to still log the original name, boardname?
>
> Thinking about it a bit more, it makes sense to log the original name rather than last name.
>>
>>
>> maybe log each failure in the loop, before calling
>> ath10k_create_reduced_boardname()?
>
> As mentioned above, it makes sense to log as debug for each failure to find and log as error if nothing matches, will make this change in next iteration.
>>
>>
>> >               ret = -ENODATA;
>> >       }
>> >
>> > @@ -1566,7 +1586,7 @@ static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
>> >
>> >   int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>> >   {
>> > -     char boardname[100], fallback_boardname1[100], fallback_boardname2[100];
>> > +     char boardname[100];
>> >       int ret;
>> >
>> >       if (bd_ie_type == ATH10K_BD_IE_BOARD) {
>> > @@ -1579,25 +1599,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>> >                       return ret;
>> >               }
>> >
>> > -             /* Without variant and only chip-id */
>> > -             ret = ath10k_core_create_board_name(ar, fallback_boardname1,
>> > -                                                 sizeof(boardname), false,
>> > -                                                 true);
>> > -             if (ret) {
>> > -                     ath10k_err(ar, "failed to create 1st fallback board name: %d",
>> > -                                ret);
>> > -                     return ret;
>> > -             }
>> > -
>> > -             /* Without variant and without chip-id */
>> > -             ret = ath10k_core_create_board_name(ar, fallback_boardname2,
>> > -                                                 sizeof(boardname), false,
>> > -                                                 false);
>> > -             if (ret) {
>> > -                     ath10k_err(ar, "failed to create 2nd fallback board name: %d",
>> > -                                ret);
>> > -                     return ret;
>> > -             }
>> >       } else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
>> >               ret = ath10k_core_create_eboard_name(ar, boardname,
>> >                                                    sizeof(boardname));
>> > @@ -1609,8 +1610,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>> >
>> >       ar->bd_api = 2;
>> >       ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
>> > -                                              fallback_boardname1,
>> > -                                              fallback_boardname2,
>> >                                                ATH10K_BOARD_API2_FILE);
>> >       if (!ret)
>> >               goto success;
>
> -Abhishek
